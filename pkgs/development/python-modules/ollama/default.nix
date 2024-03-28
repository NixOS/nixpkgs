{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, pillow
, poetry-core
, pytest-asyncio
, pytest-httpserver
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "ollama";
  version = "0.1.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ollama";
    repo = "ollama-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-xNH9kAjSdVXrCI7zkyR7tYxJ/NG8/08ykkDZQJI8Za4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${version}"
  '';

  pythonRelaxDeps = [
    "httpx"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    httpx
  ];

  nativeCheckInputs = [
    pillow
    pytest-asyncio
    pytest-httpserver
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ollama"
  ];

  meta = with lib; {
    description = "Ollama Python library";
    homepage = "https://github.com/ollama/ollama-python";
    changelog = "https://github.com/ollama/ollama-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
