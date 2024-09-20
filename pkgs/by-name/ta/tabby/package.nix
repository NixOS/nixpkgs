{ config
, lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, stdenv

, git
, openssl
, pkg-config
, protobuf

, llama-cpp

, autoAddDriverRunpath
, cudaSupport ? config.cudaSupport
, cudaPackages ? { }

, rocmSupport ? config.rocmSupport

, darwin
, metalSupport ? stdenv.isDarwin && stdenv.isAarch64

  # one of [ null "cpu" "rocm" "cuda" "metal" ];
, acceleration ? null
}:

let
  inherit (lib) optional optionals flatten;
  # References:
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/ll/llama-cpp/package.nix
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/misc/ollama/default.nix

  pname = "tabby";
  version = "0.11.1";


  availableAccelerations = flatten [
    (optional cudaSupport "cuda")
    (optional rocmSupport "rocm")
    (optional metalSupport "metal")
  ];

  warnIfMultipleAccelerationMethods = configured: (let
    len = builtins.length configured;
    result = if len == 0 then "cpu" else (builtins.head configured);
  in
    lib.warnIf (len > 1) ''
      building tabby with multiple acceleration methods enabled is not
      supported; falling back to `${result}`
    ''
    result
  );

  # If user did not not override the acceleration attribute, then try to use one of
  # - nixpkgs.config.cudaSupport
  # - nixpkgs.config.rocmSupport
  # - metal if (stdenv.isDarwin && stdenv.isAarch64)
  # !! warn if multiple acceleration methods are enabled and default to the first one in the list
  featureDevice = if (builtins.isNull acceleration) then (warnIfMultipleAccelerationMethods availableAccelerations) else acceleration;

  warnIfNotLinux = api: (lib.warnIfNot stdenv.isLinux
    "building tabby with `${api}` is only supported on linux; falling back to cpu"
    stdenv.isLinux);
  warnIfNotDarwinAarch64 = api: (lib.warnIfNot (stdenv.isDarwin && stdenv.isAarch64)
    "building tabby with `${api}` is only supported on Darwin-aarch64; falling back to cpu"
    (stdenv.isDarwin && stdenv.isAarch64));

  validAccel = lib.assertOneOf "tabby.featureDevice" featureDevice [ "cpu" "rocm" "cuda" "metal" ];

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
  darwinBuildInputs = [ llamaccpPackage ]
  ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Foundation
    Accelerate
    CoreVideo
    CoreGraphics
  ]
  ++ optionals enableMetal [ Metal MetalKit ]);

  cudaBuildInputs = [ llamaccpPackage ];
  rocmBuildInputs = [ llamaccpPackage ];

in
rustPlatform.buildRustPackage {
  inherit pname version;
  inherit featureDevice;

  src = fetchFromGitHub {
    owner = "TabbyML";
    repo = "tabby";
    rev = "v${version}";
    hash = "sha256-OgAE526aW3mVqf6fVmBmL5/B4gH9B54QLEITQk9Kgsg=";
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "apalis-0.5.1" = "sha256-hGvVuSy32lSTR5DJdiyf8q1sXbIeuLSGrtyq6m2QlUQ=";
      "tree-sitter-c-0.20.6" = "sha256-Etl4s29YSOxiqPo4Z49N6zIYqNpIsdk/Qd0jR8jdvW4=";
      "tree-sitter-cpp-0.20.3" = "sha256-UrQ48CoUMSHmlHzOMu22c9N4hxJtHL2ZYRabYjf5byA=";
      "tree-sitter-solidity-0.0.3" = "sha256-b+LthCf+g19sjKeNgXZmUV0RNi94O3u0WmXfgKRpaE0=";
    };
  };

  # https://github.com/TabbyML/tabby/blob/v0.7.0/.github/workflows/release.yml#L39
  cargoBuildFlags = [
    "--release"
    "--package" "tabby"
  ] ++ optionals enableRocm [
    "--features" "rocm"
  ] ++ optionals enableCuda [
    "--features" "cuda"
  ];

  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
    protobuf
    git
  ] ++ optionals enableCuda [
    autoAddDriverRunpath
  ];

  buildInputs = [ openssl ]
  ++ optionals stdenv.isDarwin darwinBuildInputs
  ++ optionals enableCuda cudaBuildInputs
  ++ optionals enableRocm rocmBuildInputs
  ;

  env.LLAMA_CPP_LIB = "${lib.getLib llamaccpPackage}/lib";
  patches = [ ./0001-nix-build-use-nix-native-llama-cpp-package.patch ];

  # Fails with:
  # file cannot create directory: /var/empty/local/lib64/cmake/Llama
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/TabbyML/tabby";
    changelog = "https://github.com/TabbyML/tabby/releases/tag/v${version}";
    description = "Self-hosted AI coding assistant";
    mainProgram = "tabby";
    license = licenses.asl20;
    maintainers = [ maintainers.ghthor ];
    broken = stdenv.isDarwin && !stdenv.isAarch64;
  };
}
