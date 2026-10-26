{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,

  inflection,
  pydantic,
  requests,
  urllib3,
  click,

  pytest,
  pytest-cov-stub,
  mock,
  requests-mock,
  tox,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyairtable";
  version = "3.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-apF01DgAlmZgVH4H0Ac2s6D973W1CHt27oug6AnAQu4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    setuptools
    inflection
    pydantic
    requests
    urllib3
    click
  ];

  nativeCheckInputs = [
    pytest
    pytest-cov-stub
    mock
    requests-mock
    tox
  ];

  pythonImportsCheck = [ "pyairtable" ];

  meta = {
    description = "Python API Client for Airtable";
    homepage = "https://pyairtable.readthedocs.io/";
    changelog = "https://pyairtable.readthedocs.io/en/${finalAttrs.version}/changelog.html";
    license = lib.licenses.mit;
    mainProgram = "pyairtable";
    maintainers = with lib.maintainers; [ stupidcomputer ];
  };
})
