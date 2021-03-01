{ lib
, buildPythonPackage
, fetchPypi
, pytest-asyncio
, pytest-cov
, pytestCheckHook
, requests
, werkzeug
}:

buildPythonPackage rec {
  pname = "pytest-httpserver";
  version = "0.3.7";

  src = fetchPypi {
    pname = "pytest_httpserver";
    inherit version;
    sha256 = "sha256-YgTcrUlwh2jz0tJdMUgjm8RcqrtpJ/oUQm3SnxUc5Z4=";
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
