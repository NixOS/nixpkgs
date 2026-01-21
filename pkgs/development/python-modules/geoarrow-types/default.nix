{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pyarrow,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "geoarrow-types";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "geoarrow-python";
    owner = "geoarrow";
    tag = "geoarrow-types-${version}";
    hash = "sha256-ciElwh94ukFyFdOBuQWyOUVpn4jBM1RKfxiBCcM+nmE=";
  };

  sourceRoot = "${src.name}/geoarrow-types";

  build-system = [ setuptools-scm ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    pyarrow
  ];

  pythonImportsCheck = [ "geoarrow.types" ];

  meta = {
    description = "PyArrow types for geoarrow";
    homepage = "https://github.com/geoarrow/geoarrow-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      cpcloud
    ];
  };
}
