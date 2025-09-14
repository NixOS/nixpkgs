{
  lib,
  aiohttp,
  anyio,
  buildPythonPackage,
  click,
  dirty-equals,
  distro,
  fetchPypi,
  fire,
  hatch-fancy-pypi-readme,
  hatchling,
  httpx-aiohttp,
  httpx,
  nest-asyncio,
  pandas,
  prompt-toolkit,
  pyaml,
  pydantic,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  requests,
  respx,
  rich,
  sniffio,
  termcolor,
  tqdm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "llama-stack-client";
  version = "0.2.20";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_stack_client";
    inherit version;
    hash = "sha256-NWJX8KS7tkIF+J4RPXFZJYU9XjTsdE5yRm2nJ5C6QVs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling==1.26.3" "hatchling"
  '';

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  dependencies = [
    anyio
    click
    distro
    fire
    httpx
    pandas
    prompt-toolkit
    pyaml
    pydantic
    requests
    rich
    sniffio
    termcolor
    tqdm
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

  pythonImportsCheck = [ "llama_stack_client" ];

  disabledTestPaths = [
    # Tests require network access
    "tests/api_resources/"
    "tests/test_client.py"
  ];

  meta = {
    description = "Library for the llama-stack-client API";
    homepage = "https://github.com/llamastack/llama-stack-client-python";
    changelog = "https://github.com/llamastack/llama-stack-client-python/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
