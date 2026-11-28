{
  arrow,
  buildPythonPackage,
  bytestruct,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "opack2";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "doronz88";
    repo = "opack2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JOcfchR3ga2QyvtVEWhfIplP1BwwB0SaFY1qe869wuk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    arrow
    bytestruct
  ];

  pythonImportsCheck = [ "opack2" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/doronz88/opack2/releases/tag/${finalAttrs.src.tag}";
    description = "Python library for parsing the opack format";
    homepage = "https://github.com/doronz88/opack2";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
