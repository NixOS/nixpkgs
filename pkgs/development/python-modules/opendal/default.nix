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
buildPythonPackage rec {
  pname = "opendal";
  version = "0.46.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "opendal";
    tag = "v${version}";
    hash = "sha256-OQGpz6o4R0Yp+1vAgFtik/l7wvHwJNcB1BhZLk+BFPg=";
  };

  sourceRoot = "${src.name}/bindings/python";

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
}
