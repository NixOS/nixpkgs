{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  httpx,
  llm,
  requests,
  pytest,
  pytest-asyncio,
  pytest-mock,
  pytest-vcr,
}:

buildPythonPackage rec {
  pname = "llm-lmstudio";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "agustif";
    repo = "llm-lmstudio";
    rev = "v${version}";
    hash = "sha256-dPrkvoVLDIk/JxUhvUUyjMzovH+Q/O13eTdA6qvdKxY=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    httpx
    llm
    requests
  ];

  optional-dependencies = {
    test = [
      pytest
      pytest-asyncio
      pytest-mock
      pytest-vcr
    ];
  };

  pythonImportsCheck = [
    "llm_lmstudio"
  ];

  meta = {
    description = "Plugin to use local models via LM Studio API with https://llm.datasette.io";
    homepage = "https://github.com/agustif/llm-lmstudio";
    changelog = "https://github.com/agustif/llm-lmstudio/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dwt ];
  };
}
