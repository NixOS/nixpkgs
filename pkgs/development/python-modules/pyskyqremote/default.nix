{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
  websocket-client,
  xmltodict,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyskyqremote";
  version = "0.3.26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RogerSelwyn";
    repo = "skyq_remote";
    tag = finalAttrs.version;
    hash = "sha256-aMgUwgKHgR+NQvRxiUV7GaXehjDIlJJJHwSmHDmzK08=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    websocket-client
    xmltodict
  ];

  # Project has no tests, only a test script which looks like anusage example
  doCheck = false;

  pythonImportsCheck = [ "pyskyqremote" ];

  meta = {
    description = "Python module for accessing SkyQ boxes";
    homepage = "https://github.com/RogerSelwyn/skyq_remote";
    changelog = "https://github.com/RogerSelwyn/skyq_remote/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
