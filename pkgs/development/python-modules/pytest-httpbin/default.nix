{ lib
, buildPythonPackage
, fetchFromGitHub
, httpbin
, pytest
, pytestCheckHook
, pythonOlder
, requests
, six
}:

buildPythonPackage rec {
  pname = "pytest-httpbin";
  version = "1.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kevin1024";
    repo = "pytest-httpbin";
    rev = "v${version}";
    hash = "sha256-S4ThQx4H3UlKhunJo35esPClZiEn7gX/Qwo4kE1QMTI=";
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
