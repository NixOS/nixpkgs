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
  version = "1.0.4";

  src = fetchPypi {
    pname = "pytest_httpserver";
    inherit version;
    sha256 = "6de464ba5f74628d6182ebbdcb56783edf2c9b0caf598dc35c11f014f24a3f0d";
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
