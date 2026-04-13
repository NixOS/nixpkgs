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
  typing-extensions,

  # optional dependencies
  google-auth,
  boto3,
  botocore,
  aiohttp,
  httpx-aiohttp,

  # test
  dirty-equals,
  http-snapshot,
  inline-snapshot,
  nest-asyncio,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  respx,
}:

buildPythonPackage (finalAttrs: {
  pname = "anthropic";
  version = "0.94.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "anthropic-sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gh7My8ftI2o0CxrwuVsbr8tdZ2MtKdRw0mfQxb7REJk=";
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
    typing-extensions
  ];

  optional-dependencies = {
    aiohttp = [
      aiohttp
      httpx-aiohttp
    ];
    bedrock = [
      boto3
      botocore
    ];
    vertex = [ google-auth ] ++ google-auth.optional-dependencies.requests;
  };

  nativeCheckInputs = [
    dirty-equals
    http-snapshot
    inline-snapshot
    nest-asyncio
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    respx
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

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
    changelog = "https://github.com/anthropics/anthropic-sdk-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.natsukium
      lib.maintainers.sarahec
    ];
  };
})
