{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "flask-paginate";
  version = "2024.4.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lixxu";
    repo = "flask-paginate";
    rev = "refs/tags/v${version}";
    hash = "sha256-YaAgl+iuoXB0eWVzhmNq2UTOpM/tHfDISIb9CyaXiuA=";
  };

  propagatedBuildInputs = [
    flask
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "flask_paginate"
  ];

  pytestFlagsArray = [
    "tests/tests.py"
  ];

  meta = with lib; {
    description = "Pagination support for Flask";
    homepage = "https://github.com/lixxu/flask-paginate";
    changelog = "https://github.com/lixxu/flask-paginate/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
