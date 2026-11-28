{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  requests,
  requests-mock,
  xmltodict,
}:

buildPythonPackage (finalAttrs: {
  pname = "meteoalarmapi";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mastermc0";
    repo = "meteoalarmapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5GZ5XHZmLcE7y6B2VCPeQDU8JbJl5O8DfYs92mtUtcU=";
  };

  build-system = [ hatchling ];

  dependencies = [
    requests
    xmltodict
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  disabledTests = [
    # Attempts a real DNS lookup to simulate a connection failure.
    "test_server_not_reachable"
    # Expects a 404 response from the live MeteoAlarm feed.
    "test_wrong_country_name"
  ];

  pythonImportsCheck = [ "meteoalarmapi" ];

  meta = {
    description = "Python library for European weather alerts from MeteoAlarm.org";
    homepage = "https://github.com/mastermc0/meteoalarmapi";
    changelog = "https://github.com/mastermc0/meteoalarmapi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
