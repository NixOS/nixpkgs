{
  config,
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  stdenv,

  git,
  openssl,
  pkg-config,
  protobuf,

  llama-cpp,

  apple-sdk_15,
  autoAddDriverRunpath,
  versionCheckHook,

  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
  metalSupport ? stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64,
  # one of [ null "cpu" "rocm" "cuda" "metal" ];
  acceleration ? null,
}:

let
  inherit (lib) optional optionals flatten;
  # References:
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/ll/llama-cpp/package.nix
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/misc/ollama/default.nix

  pname = "tabby";
  version = "0.20.0";

  availableAccelerations = flatten [
    (optional cudaSupport "cuda")
    (optional rocmSupport "rocm")
    (optional metalSupport "metal")
  ];

  warnIfMultipleAccelerationMethods =
    configured:
    (
      let
        len = builtins.length configured;
        result = if len == 0 then "cpu" else (builtins.head configured);
      in
      lib.warnIf (len > 1) ''
        building tabby with multiple acceleration methods enabled is not
        supported; falling back to `${result}`
      '' result
    );

  # If user did not not override the acceleration attribute, then try to use one of
  # - nixpkgs.config.cudaSupport
  # - nixpkgs.config.rocmSupport
  # - metal if (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64)
  # !! warn if multiple acceleration methods are enabled and default to the first one in the list
  featureDevice =
    if (builtins.isNull acceleration) then
      (warnIfMultipleAccelerationMethods availableAccelerations)
    else
      acceleration;

  warnIfNotLinux =
    api:
    (lib.warnIfNot stdenv.hostPlatform.isLinux
      "building tabby with `${api}` is only supported on linux; falling back to cpu"
      stdenv.hostPlatform.isLinux
    );
  warnIfNotDarwinAarch64 =
    api:
    (lib.warnIfNot (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64)
      "building tabby with `${api}` is only supported on Darwin-aarch64; falling back to cpu"
      (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64)
    );

  validAccel = lib.assertOneOf "tabby.featureDevice" featureDevice [
    "cpu"
    "rocm"
    "cuda"
    "metal"
  ];

  # TODO(ghthor): there is a bug here where featureDevice could be cuda, but enableCuda is false
  #  The would result in a startup failure of the service module.
  enableRocm = validAccel && (featureDevice == "rocm") && (warnIfNotLinux "rocm");
  enableCuda = validAccel && (featureDevice == "cuda") && (warnIfNotLinux "cuda");
  enableMetal = validAccel && (featureDevice == "metal") && (warnIfNotDarwinAarch64 "metal");

  # We have to use override here because tabby doesn't actually tell llama-cpp
  # to use a specific device type as it is relying on llama-cpp only being
  # built to use one type of device.
  #
  # See: https://github.com/TabbyML/tabby/blob/v0.11.1/crates/llama-cpp-bindings/include/engine.h#L20
  #
  llamaccpPackage = llama-cpp.override {
    rocmSupport = enableRocm;
    cudaSupport = enableCuda;
    metalSupport = enableMetal;
  };

  # TODO(ghthor): some of this can be removed
  darwinBuildInputs =
    [ llamaccpPackage ]
    ++ optionals stdenv.hostPlatform.isDarwin ([
      apple-sdk_15
    ]);

  cudaBuildInputs = [ llamaccpPackage ];
  rocmBuildInputs = [ llamaccpPackage ];

in
rustPlatform.buildRustPackage {
  inherit pname version;
  inherit featureDevice;

  src = fetchFromGitHub {
    owner = "TabbyML";
    repo = "tabby";
    rev = "refs/tags/v${version}";
    hash = "sha256-Vhl5oNVYY3pizoA0PuV4c9UXH3F2L+WiXQMOM0Pqxks=";
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ollama-rs-0.1.9" = "sha256-d6sKUxc8VQbRkVqMOeNFqDdKesq5k32AQShK67y2ssg=";
      "oneshot-0.1.6" = "sha256-PmYuHuNTqToMyMHPRFDUaHUvFkVftx9ZCOBwXj+4Hc4=";
      "ownedbytes-0.7.0" = "sha256-p0+ohtW0VLmfDTZw/LfwX2gYfuYuoOBcE+JsguK7Wn8=";
      "sqlx-0.7.4" = "sha256-tcISzoSfOZ0jjNgGpuPPxjMxmBUPw/5FVDoALZEAHKY=";
      "tree-sitter-c-0.21.3" = "sha256-ucbHLS2xyGo1uyKZv/K1HNXuMo4GpTY327cgdVS9F3c=";
      "tree-sitter-cpp-0.22.1" = "sha256-3akSuQltFMF6I32HwRU08+Hcl9ojxPGk2ZuOX3gAObw=";
      "tree-sitter-solidity-1.2.6" = "sha256-S00hdzMoIccPYBEvE092/RIMnG8YEnDGk6GJhXlr4ng=";
    };
  };

  # https://github.com/TabbyML/tabby/blob/v0.7.0/.github/workflows/release.yml#L39
  cargoBuildFlags =
    [
      # Don't need to build llama-cpp-server (included in default build)
      "--no-default-features"
      "--features"
      "ee"
      "--package"
      "tabby"
    ]
    ++ optionals enableRocm [
      "--features"
      "rocm"
    ]
    ++ optionals enableCuda [
      "--features"
      "cuda"
    ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  nativeBuildInputs =
    [
      git
      pkg-config
      protobuf
    ]
    ++ optionals enableCuda [
      autoAddDriverRunpath
    ];

  buildInputs =
    [ openssl ]
    ++ optionals stdenv.hostPlatform.isDarwin darwinBuildInputs
    ++ optionals enableCuda cudaBuildInputs
    ++ optionals enableRocm rocmBuildInputs;

  postInstall = ''
    # NOTE: Project contains a subproject for building llama-server
    # But, we already have a derivation for this
    ln -s ${lib.getExe' llama-cpp "llama-server"} $out/bin/llama-server
  '';

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  # Fails with:
  # file cannot create directory: /var/empty/local/lib64/cmake/Llama
  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/TabbyML/tabby";
    changelog = "https://github.com/TabbyML/tabby/releases/tag/v${version}";
    description = "Self-hosted AI coding assistant";
    mainProgram = "tabby";
    license = licenses.asl20;
    maintainers = [ maintainers.ghthor ];
    broken = stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isAarch64;
  };
}
