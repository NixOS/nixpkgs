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
  version = "1.0.1";

  src = fetchPypi {
    pname = "pytest_httpserver";
    inherit version;
    sha256 = "12b0028vp5rh9bg712klgjzm4vl4biyza1j6iyv3pgg25ircang3";
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
