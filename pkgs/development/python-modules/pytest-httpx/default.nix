{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, pytest
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "pytest-httpx";
  version = "0.22.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Colin-b";
    repo = "pytest_httpx";
    rev = "refs/tags/v${version}";
    hash = "sha256-J5Y5G3/8d9hAtDFqweqA73amnXUpPbmb0uTrCslpl9k=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    httpx
  ];

  pythonRelaxDeps = [
    "httpx"
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
    changelog = "https://github.com/Colin-b/pytest_httpx/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
