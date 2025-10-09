{
  lib,
  buildPythonPackage,
  fetchPypi,
  dulwich,
  everett,
  importlib-metadata,
  jsonschema,
  numpy,
  psutil,
  python-box,
  requests,
  requests-toolbelt,
  rich,
  semantic-version,
  sentry-sdk,
  setuptools,
  simplejson,
  urllib3,
  wrapt,
  wurlitzer,
}:

buildPythonPackage rec {
  pname = "comet-ml";
  version = "3.53.0";

  src = fetchPypi {
    pname = "comet_ml";
    inherit version;
    hash = "sha256-KYMe6lDNj5nyXaB0hsk2STwGATkAuRwr8SSzlz3W4tA=";
  };

  pyproject = true;
  build-system = [
    setuptools
  ];

  dependencies = [
    dulwich
    everett
    importlib-metadata
    jsonschema
    numpy
    psutil
    python-box
    requests
    requests-toolbelt
    rich
    semantic-version
    sentry-sdk
    simplejson
    urllib3
    wrapt
    wurlitzer
  ];

  pythonRelaxDeps = [
    "everett"
    "python-box"
  ];

  pythonImportsCheck = [ "comet_ml" ];

  meta = {
    description = "Platform designed to help machine learning teams track, compare, explain, and optimize their models";
    homepage = "https://www.comet.com/site/";
    changelog = "https://www.comet.com/docs/v2/api-and-sdk/python-sdk/releases/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "comet";
  };
}
