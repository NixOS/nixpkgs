{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  poetry-core,

  # dependencies
  certifi,
  expiringdict,
  launchdarkly-eventsource,
  pyrfc3339,
  semver,
  urllib3,

  # tests
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "launchdarkly-server-sdk";
  version = "9.15.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    pname = "launchdarkly_server_sdk";
    inherit version;
    hash = "sha256-8xRBt0vBppw4HbV8MxFlCeQHomEmKK1t/wp9uznVAgs=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    certifi
    expiringdict
    launchdarkly-eventsource
    pyrfc3339
    semver
    urllib3
  ];

  pythonImportsCheck = [ "ldclient" ];

  meta = {
    description = "LaunchDarkly Server-side SDK for Python";
    homepage = "https://github.com/launchdarkly/python-server-sdk";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
