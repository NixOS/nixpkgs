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

buildPythonPackage rec {
  pname = "groq";
  version = "0.31.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "groq";
    repo = "groq-python";
    tag = "v${version}";
    hash = "sha256-vckFFnk66gkxaoqKpjykkpQIbiWqUyuTDgSvhKqsC4A=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling==1.26.3" \
      "hatchling>=1.26.3"
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
  ++ lib.flatten (builtins.attrValues optional-dependencies);

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
    changelog = "https://github.com/groq/groq-python/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fab
      sarahec
    ];
  };
}
