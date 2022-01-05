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
  version = "1.0.3";

  src = fetchPypi {
    pname = "pytest_httpserver";
    inherit version;
    sha256 = "87561c4fa6a7bc306d76d1979a3eb9d54eb26bfb2f3f51f1643bf3c090ce629d";
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
