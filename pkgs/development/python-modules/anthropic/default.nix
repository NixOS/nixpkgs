{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-fancy-pypi-readme,
  hatchling,

  # dependencies
  anyio,
  distro,
  httpx,
  jiter,
  pydantic,
  sniffio,
  tokenizers,
  typing-extensions,

  # optional dependencies
  google-auth,

  # test
  dirty-equals,
  nest-asyncio,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  respx,
}:

buildPythonPackage rec {
  pname = "anthropic";
  version = "0.59.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "anthropic-sdk-python";
    tag = "v${version}";
    hash = "sha256-JUgJB0+9zfmj3asjn7FOozNB9STkKEvObbTP3KLDV+M=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"hatchling==1.26.3"' '"hatchling>=1.26.3"'
  '';

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    anyio
    distro
    httpx
    jiter
    pydantic
    sniffio
    tokenizers
    typing-extensions
  ];

  optional-dependencies = {
    vertex = [ google-auth ];
  };

  nativeCheckInputs = [
    dirty-equals
    nest-asyncio
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "anthropic" ];

  disabledTests = [
    # Test require network access
    "test_copy_build_request"
  ];

  disabledTestPaths = [
    # Test require network access
    "tests/api_resources"
    "tests/lib/test_bedrock.py"
  ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  meta = {
    description = "Anthropic's safety-first language model APIs";
    homepage = "https://github.com/anthropics/anthropic-sdk-python";
    changelog = "https://github.com/anthropics/anthropic-sdk-python/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.natsukium
      lib.maintainers.sarahec
    ];
  };
}
