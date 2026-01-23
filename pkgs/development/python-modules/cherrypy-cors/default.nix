{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  httpagentparser,
  cherrypy,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "cherrypy-cors";
  version = "1.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gzhM1mSnq4uat9SSb+lxOs/gvONmXuKBiaD6BLnyEtY=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    httpagentparser
    cherrypy
  ];

  pythonImportsCheck = [ "cherrypy_cors" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "CORS support for CherryPy";
    homepage = "https://github.com/cherrypy/cherrypy-cors";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpts ];
  };
}
