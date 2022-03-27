{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "cppy";
  version = "1.2.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-leiGLk+CbD8qa3tlgzOxYvgMvp+UOqDQp6ay74UK7/w=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cppy" ];

  meta = {
    description = "C++ headers for C extension development";
    homepage = "https://github.com/nucleic/cppy";
    license = lib.licenses.bsd3;
  };
}
