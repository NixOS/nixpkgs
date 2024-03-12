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
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-httpx";
  version = "0.30.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Colin-b";
    repo = "pytest_httpx";
    rev = "refs/tags/v${version}";
    hash = "sha256-JfyqeOCHNHO4IEHVrh47TdWvb8lcy/1Prqnfphs0ufM=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
    setuptools-scm
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
