{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build
, poetry-core

# runtime
, backports-zoneinfo

# tests
, pytestCheckHook
, freezegun
}:

buildPythonPackage rec {
  pname = "astral";
  version = "3.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m3w7QS6eadFyz7JL4Oat3MnxvQGijbi+vmbXXMxTPYg=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  checkInputs = [
    freezegun
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/sffjunkie/astral/releases/tag/${version}";
    description = "Calculations for the position of the sun and the moon";
    homepage = "https://github.com/sffjunkie/astral/";
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli ];
  };
}
