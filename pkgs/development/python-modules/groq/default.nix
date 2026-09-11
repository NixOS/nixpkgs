{
  lib,
  aiohttp,
  anyio,
  buildPythonPackage,
  dirty-equals,
  distro,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatchling,
  httpx-aiohttp,
  httpx,
  nest-asyncio,
  pydantic,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  respx,
  sniffio,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "groq";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "groq";
    repo = "groq-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GqGiD4gwroz5i0W2MewgId+bliPTmmSGR/zMs9EV7q8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling==1.26.3" "hatchling>=1.26.3"
  '';

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  dependencies = [
    anyio
    distro
    httpx
    pydantic
    sniffio
    typing-extensions
  ];

  optional-dependencies = {
    aiohttp = [
      aiohttp
      httpx-aiohttp
    ];
  };

  nativeCheckInputs = [
    dirty-equals
    nest-asyncio
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    respx
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "groq" ];

  disabledTests = [
    # Tests require network access
    "test_method"
    "test_streaming"
    "test_raw_response"
    "test_copy_build_request"
  ];

  meta = {
    description = "Library for the Groq API";
    homepage = "https://github.com/groq/groq-python";
    changelog = "https://github.com/groq/groq-python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fab
      sarahec
    ];
  };
})
