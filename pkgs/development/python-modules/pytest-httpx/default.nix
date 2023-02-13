{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, pytest
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-httpx";
  version = "0.21.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Colin-b";
    repo = "pytest_httpx";
    rev = "refs/tags/v${version}";
    hash = "sha256-pIYSXmOxLfWknWTfrnhslx76UMSSlnqzFE7qvJo1mz4=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    httpx
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_httpx"
  ];

  meta = with lib; {
    description = "Send responses to httpx";
    homepage = "https://github.com/Colin-b/pytest_httpx";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
