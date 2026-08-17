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
  versionCheckHook,
  wrapt,
  wurlitzer,
}:

buildPythonPackage (finalAttrs: {
  pname = "comet-ml";
  version = "3.58.3";
  pyproject = true;
  __structuredAttrs = true;

  # No GitHub repository
  src = fetchPypi {
    pname = "comet_ml";
    inherit (finalAttrs) version;
    hash = "sha256-fl+9ywbh3g1/mXRavW4V5aaLDyHcpUu+dMK4mQGVkEE=";
  };

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

  nativeCheckInputs = [
    versionCheckHook
    # Skip pytestCheckHook, as Python tests require a lot of additional dependencies to run.
  ];

  meta = {
    description = "Platform designed to help machine learning teams track, compare, explain, and optimize their models";
    homepage = "https://www.comet.com/site/";
    changelog = "https://www.comet.com/docs/v2/api-and-sdk/python-sdk/releases/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "comet";
  };
})
