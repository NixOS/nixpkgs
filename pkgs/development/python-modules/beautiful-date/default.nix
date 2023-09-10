{ lib
, buildPythonPackage
, fetchFromGitHub
, python-dateutil
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "beautiful-date";
  version = "2.2.0";
  format = "setuptools";

  disable = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kuzmoyev";
    repo = "beautiful-date";
    rev = "v${version}";
    hash = "sha256-5xRmHaAPf1ps75cOINHkHT1aYb5UGLZGl0OHVQaMES0=";
  };

  propagatedBuildInputs = [
    python-dateutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "beautiful_date" ];

  meta = with lib; {
    description = "Simple and beautiful way to create date and datetime objects in Python";
    homepage = "https://github.com/kuzmoyev/beautiful-date";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
