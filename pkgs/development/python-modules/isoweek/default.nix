{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "isoweek";
  version = "1.3.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c/P3usRD4Fo6tFwypyBIsMTybVPYFGLsSxQsdYHT/+g=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "isoweek" ];

  meta = {
    description = "Module work with ISO weeks";
    homepage = "https://github.com/gisle/isoweek";
    changelog = "https://github.com/gisle/isoweek/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mrmebelman ];
  };
}
