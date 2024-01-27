{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, pytest
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, setuptools
}:

buildPythonPackage rec {
  pname = "pytest-httpx";
  version = "0.27.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Colin-b";
    repo = "pytest_httpx";
    rev = "refs/tags/v${version}";
    hash = "sha256-5CDmIjehW9/aBxoFVbo8W2fAwgIrPPxEqHQjxsTPlpY=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
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
