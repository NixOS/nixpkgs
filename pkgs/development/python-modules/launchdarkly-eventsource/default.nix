{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  poetry-core,

  # dependencies
  urllib3,

  # tests
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "launchdarkly-eventsource";
  version = "1.5.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "launchdarkly_eventsource";
    inherit version;
    hash = "sha256-8SL4CzbbbqGrIK9iyCuLJmhoIlm0FQU8lEAN1sB5Iqc=";
  };

  build-system = [ poetry-core ];

  dependencies = [ urllib3 ];

  pythonImportsCheck = [ "ld_eventsource" ];

  meta = {
    description = "LaunchDarkly SSE client for Python";
    homepage = "https://github.com/launchdarkly/python-eventsource";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
