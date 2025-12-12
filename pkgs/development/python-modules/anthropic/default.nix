{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,

  # build-system
  hatch-fancy-pypi-readme,
  hatchling,

  # dependencies
  anyio,
  distro,
  docstring-parser,
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
  inline-snapshot,
  nest-asyncio,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  respx,
}:

buildPythonPackage rec {
  pname = "anthropic";
  version = "0.75.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "anthropic-sdk-python";
    tag = "v${version}";
    hash = "sha256-wwaH9/o7qr8eXKvmKpj+/ubOdDydcXId/qiA6dXpd2I=";
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
    docstring-parser
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
    inline-snapshot
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Hangs
    # https://github.com/anthropics/anthropic-sdk-python/issues/1008
    "test_get_platform"
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
