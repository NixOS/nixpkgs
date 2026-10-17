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
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "opendal";
    tag = "v0.59.3";
    hash = "sha256-pve2LwMtgfdRjC363eDp7Zz5YR09M3zHYBRgbDuDkKk=";
  };

  sourceRoot = "${finalAttrs.src.name}/bindings/python";

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
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
