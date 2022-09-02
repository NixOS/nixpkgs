{ lib
, buildPythonPackage
, fetchPypi
, pytest-cov
, pytestCheckHook
, requests
, werkzeug
}:

buildPythonPackage rec {
  pname = "pytest-httpserver";
  version = "1.0.5";

  src = fetchPypi {
    pname = "pytest_httpserver";
    inherit version;
    sha256 = "sha256-rjKWYm0KEOg1qfQjxhtFQFR9WCQivgVMP8wIYmuqECQ=";
  };

  propagatedBuildInputs = [ werkzeug ];

  checkInputs = [
    pytest-cov
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "pytest_httpserver" ];

  meta = with lib; {
    description = "HTTP server for pytest to test HTTP clients";
    homepage = "https://www.github.com/csernazs/pytest-httpserver";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
