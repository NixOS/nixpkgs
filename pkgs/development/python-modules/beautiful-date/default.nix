{ lib
, buildPythonPackage
, fetchFromGitHub
, freezegun
, python-dateutil
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "beautiful-date";
  version = "2.3.0";
  format = "setuptools";

  disable = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kuzmoyev";
    repo = "beautiful-date";
    rev = "refs/tags/v${version}";
    hash = "sha256-e6YJBaDwWqVehxBPOvsIdV4FIXlIwj29H5untXGJvT0=";
  };

  propagatedBuildInputs = [
    python-dateutil
  ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "beautiful_date"
  ];

  meta = with lib; {
    description = "Simple and beautiful way to create date and datetime objects";
    homepage = "https://github.com/kuzmoyev/beautiful-date";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
