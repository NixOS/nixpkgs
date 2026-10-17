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
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "geoarrow-python";
    owner = "geoarrow";
    tag = "geoarrow-types-${version}";
    hash = "sha256-b9nFl866x7PGPYihiYYJoIO8dJ+DgI7gxDbsaJTN6Lc=";
  };

  sourceRoot = "${src.name}/geoarrow-types";

  build-system = [ setuptools-scm ];

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
