{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "poetry-semver";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2Am2Eqons5vy0PydMbT0gJsOlyZGxfGc+kbHJbdjiBA=";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A semantic versioning library for Python.";
    homepage = "https://github.com/python-poetry/semver";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
