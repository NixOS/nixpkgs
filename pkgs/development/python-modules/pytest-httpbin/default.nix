{ lib
, buildPythonPackage
, fetchFromGitHub
, httpbin
, pytest
, pytestCheckHook
, requests
, six
}:

buildPythonPackage rec {
  pname = "pytest-httpbin";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "kevin1024";
    repo = "pytest-httpbin";
    rev = "v${version}";
    hash = "sha256-Vngd8Vum96+rdG8Nz1+aHrO6WZjiAz+0CeIovaH8N+s=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    httpbin
    six
  ];

  preCheck = ''
    # Remove assertion that doesn't hold for Flask 2.1.0
    substituteInPlace tests/test_server.py \
      --replace "assert response.headers['Location'].startswith('https://')" ""
  '';

  checkInputs = [
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [
    "pytest_httpbin"
  ];

  meta = with lib; {
    description = "Test your HTTP library against a local copy of httpbin.org";
    homepage = "https://github.com/kevin1024/pytest-httpbin";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
