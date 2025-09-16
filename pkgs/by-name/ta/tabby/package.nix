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
  cmake,

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
  version = "0.28.0";

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
  darwinBuildInputs = [
    llamaccpPackage
  ]
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
    tag = "v${version}";
    hash = "sha256-cdY1/k7zZ4am6JP9ghnnJFHop/ZcnC/9alzd2MS8xqc=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-yEns0QAARmuV697/na08K8uwJWZihY3pMyCZcERDlFM=";

  # Don't need to build llama-cpp-server (included in default build)
  # We also don't add CUDA features here since we're using the overridden llama-cpp package
  cargoBuildFlags = [
    "--no-default-features"
    "--features"
    "ee"
    "--package"
    "tabby"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  nativeBuildInputs = [
    git
    pkg-config
    protobuf
    cmake
  ]
  ++ optionals enableCuda [
    autoAddDriverRunpath
  ];

  buildInputs = [
    openssl
  ]
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

  meta = {
    homepage = "https://github.com/TabbyML/tabby";
    changelog = "https://github.com/TabbyML/tabby/releases/tag/v${version}";
    description = "Self-hosted AI coding assistant";
    mainProgram = "tabby";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ghthor ];
    broken = stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isAarch64;
  };
}
