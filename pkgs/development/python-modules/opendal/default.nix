{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # tests
  pytest-asyncio,
  pytestCheckHook,
  python-dotenv,
}:
buildPythonPackage (finalAttrs: {
  pname = "opendal";
  version = "0.47.10";
  # The OpenDAL core and Python bindings use independent versions.
  coreVersion = "0.59.3";
  hash = "sha256-pve2LwMtgfdRjC363eDp7Zz5YR09M3zHYBRgbDuDkKk=";
  cargoLockFile = ./Cargo.lock;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "opendal";
    tag = "v${finalAttrs.coreVersion}";
    hash = finalAttrs.hash;
  };

  sourceRoot = "${finalAttrs.src.name}/bindings/python";

  postPatch = ''
    ln -s ${finalAttrs.cargoLockFile} Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = finalAttrs.cargoLockFile;
  };

  env = {
    PYO3_USE_ABI3_FORWARD_COMPATIBILITY = 1;
  };

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pythonImportsCheck = [ "opendal" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    python-dotenv
  ];

  meta = {
    description = "native Python binding for Apache OpenDAL";
    homepage = "https://github.com/apache/opendal/blob/main/bindings/python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
