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
  pytest-cov,
  mock,
  requests-mock,
  tox,
}:

buildPythonPackage rec {
  pname = "pyairtable";
  version = "3.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sYX+8SEZ8kng5wSrTksVopCA/Ikq1NVRoQU6G7YJ7y4=";
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
    pytest-cov
    mock
    requests-mock
    tox
  ];

  pythonImportsCheck = [ "pyairtable" ];

  meta = {
    description = "Python API Client for Airtable";
    homepage = "https://pyairtable.readthedocs.io/";
    changelog = "https://pyairtable.readthedocs.io/en/${version}/changelog.html";
    license = lib.licenses.mit;
    mainProgram = "pyairtable";
    maintainers = with lib.maintainers; [ stupidcomputer ];
  };
}
