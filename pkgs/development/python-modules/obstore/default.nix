{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # tests
  docker,
  minio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "obstore";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "developmentseed";
    repo = "obstore";
    tag = "py-v${version}";
    hash = "sha256-usLIJsnH14Dtb8YNYu8CwHKZH8e0YVPMK44bjDkfOqE=";
  };

  patches = [
    ./update-object_store-dep.patch
  ];

  # sourceRoot = "${src.name}/obstore";
  # cargoRoot = "..";
  buildAndTestSubdir = "obstore";

  postPatch = ''
    # substituteInPlace Cargo.toml \
    #   --replace-fail \
    #     'object_store = "0.12.3"' \
    #     'object_store = "0.12.4"'
    #
    # substituteInPlace pyo3-object_store/Cargo.toml \
    #   --replace-fail \
    #     'object_store = { version = "0.12"' \
    #     'object_store = { version = "0.12.4"'

    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "pyo3-file-0.13.0" = "sha256-XHeV4T+l5QDNTDAkQEfrSom90fRCgDDEAKrKrypk36k=";
    };
  };

  # cargoDeps = rustPlatform.fetchCargoVendor {
  #   inherit
  #     pname
  #     version
  #     src
  #     patches
  #     # sourceRoot
  #     # cargoRoot
  #     # cargoPatches
  #     ;
  #   hash = "sha256-m3SNWjHsQcrH6v8Z6CnURhuXNQRgvtGreM0g91rOv6Q=";
  # };

  build-system = [
    rustPlatform.maturinBuildHook
  ];

  pythonImportsCheck = [ "obstore" ];

  nativeCheckInputs = [
    docker
    minio
    pytestCheckHook
  ];

  meta = {
    description = "Simple, high-throughput Python interface to S3, GCS & Azure Storage, powered by Rust";
    homepage = "https://github.com/developmentseed/obstore";
    changelog = "https://github.com/developmentseed/obstore/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
