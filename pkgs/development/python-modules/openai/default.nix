{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,
  hatch-fancy-pypi-readme,

  # dependencies
  anyio,
  cached-property,
  distro,
  httpx,
  jiter,
  pydantic,
  sniffio,
  tqdm,
  typing-extensions,

  numpy,
  pandas,
  pandas-stubs,

  # check deps
  pytestCheckHook,
  dirty-equals,
  inline-snapshot,
  pytest-asyncio,
  pytest-mock,
  respx,

}:

buildPythonPackage rec {
  pname = "openai";
  version = "1.47.1";
  pyproject = true;

  disabled = pythonOlder "3.7.1";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "openai-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-8zH9G28Z4CpbqQxGkPnKiD4DxasuDuK1t4jr9PpPv3I=";
  };

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
    tqdm
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.8") [ cached-property ];

  passthru.optional-dependencies = {
    datalib = [
      numpy
      pandas
      pandas-stubs
    ];
  };

  pythonImportsCheck = [ "openai" ];

  nativeCheckInputs = [
    pytestCheckHook
    dirty-equals
    inline-snapshot
    pytest-asyncio
    pytest-mock
    respx
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  disabledTests = [
    # Tests make network requests
    "test_copy_build_request"
    "test_basic_attribute_access_works"
  ];

  disabledTestPaths = [
    # Test makes network requests
    "tests/api_resources"
  ];

  meta = with lib; {
    description = "Python client library for the OpenAI API";
    homepage = "https://github.com/openai/openai-python";
    changelog = "https://github.com/openai/openai-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ malo ];
    mainProgram = "openai";
  };
}
