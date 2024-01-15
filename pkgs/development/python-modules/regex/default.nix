{ lib
, buildPythonPackage
, fetchPypi
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "regex";
  version = "2023.10.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P+9PhE0ikO4LpXrdzsF+7J499z8QonSEhd/Wo6GIzA8=";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  pythonImportsCheck = [
    "regex"
  ];

  meta = with lib; {
    description = "Alternative regular expression module, to replace re";
    homepage = "https://bitbucket.org/mrabarnett/mrab-regex";
    license = licenses.psfl;
    maintainers = with maintainers; [ abbradar ];
  };
}
