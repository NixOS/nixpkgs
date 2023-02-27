{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, python
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

  pythonImportsCheck = [
    "awacs"
  ];

  meta = with lib; {
    description = "AWS Access Policy Language creation library";
    homepage = "https://github.com/cloudtools/awacs";
    changelog = "https://github.com/cloudtools/awacs/blob/${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jlesquembre ];
  };
}
