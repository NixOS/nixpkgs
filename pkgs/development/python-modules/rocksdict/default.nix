{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pkgs,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "rocksdict";
  version = "0.3.29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rocksdict";
    repo = "RocksDict";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-yP+OAVioKOGPvcYM8s1TTNHzzaFxw1sUQDrWxmptuJo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src pname version;
    hash = "sha256-E7DrHMla7af7IjPxS5EV2bWorXjHCsclnONVkkLAUrk=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  env = {
    # libclang.so
    LIBCLANG_PATH = "${lib.getLib pkgs.libclang}/lib";
  };

  maturinBuildFlags = [
    # We disable LTO because it is incompatible with gcc
    # LTO is only supported with clang. Either disable the `lto` feature or set
    # `CC=/usr/bin/clang CXX=/usr/bin/clang++` environment variables.

    # Disable all default features to get rid of "lto"
    "--no-default-features"
    # Manually re-enable bindgen-runtime
    "--features bindgen-runtime"
  ];

  pythonImportsCheck = [ "rocksdict" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
  enabledTestPaths = [
    "test"
  ];

  # Trace/BPT Trap 5 calling `pytest` on darwin.
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Python fast on-disk dictionary / RocksDB & SpeeDB Python binding";
    homepage = "https://github.com/rocksdict/RocksDict";
    changelog = "https://github.com/rocksdict/RocksDict/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
