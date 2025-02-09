{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, setuptools-scm
, httpagentparser
, cherrypy
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "cherrypy-cors";
  version = "1.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "CORS support for CherryPy";
    homepage = "https://github.com/cherrypy/cherrypy-cors";
    license = licenses.mit;
    maintainers = with maintainers; [ jpts ];
  };
}
