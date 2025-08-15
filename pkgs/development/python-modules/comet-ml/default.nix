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
  version = "3.49.11";

  src = fetchPypi {
    pname = "comet_ml";
    inherit version;
    hash = "sha256-MinHgBWPjjSQzM6H+DL0CJRbZQcz1lBKMFM3W8Tjj0A=";
  };

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
    setuptools
    simplejson
    urllib3
    wrapt
    wurlitzer
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
