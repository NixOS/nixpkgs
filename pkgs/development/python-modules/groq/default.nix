{
  lib,
  buildPythonPackage,
  pytestCheckHook,
  pytest-asyncio,
  dirty-equals,
  fetchPypi,
  hatch-fancy-pypi-readme,
  hatchling,
  cached-property,
  distro,
  httpx,
  pydantic,
  sniffio,
  anyio,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "groq";
  version = "0.11.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-27mu/t84jd1IAex78+un9e22eUj+wM0oKdlyRAWfQqc=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    dirty-equals
  ];

  # Needed network access!
  disabledTestPaths = [
    "tests/test_client.py"
    "tests/api_resources"
  ];

  disabledTests = [
    "test_response"
  ];

  pytestFlagsArray = [
    "-Wignore::DeprecationWarning"
  ];


  dependencies = [
    anyio
    distro
    httpx
    pydantic
    sniffio
    typing-extensions
  ];

  pythonImportsCheck = [
    "groq"
  ];

  meta = {
    description = "Official Python library for the groq API";
    homepage = "https://github.com/groq/groq-python/";
    changelog = "https://github.com/groq/groq-python/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ giuliococconi ];
  };
}
