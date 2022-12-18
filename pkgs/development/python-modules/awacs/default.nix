{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, python

  # python dependencies
, typing-extensions
}:

buildPythonPackage rec {
  pname = "awacs";
  version = "2.3.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0tizZWcHe1qbLxpXS/IngExaFFUHZyXXlksWcNL/vEw=";
  };

  propagatedBuildInputs = lib.lists.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  pythonImportsCheck = [ "awacs" ];

  meta = with lib; {
    description = "AWS Access Policy Language creation library";
    maintainers = with maintainers; [ jlesquembre ];
    license = licenses.bsd2;
    homepage = "https://github.com/cloudtools/awacs";
  };
}
