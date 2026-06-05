{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  websocket-client,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "pyskyqremote";
  version = "0.3.26";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "RogerSelwyn";
    repo = "skyq_remote";
    tag = version;
    hash = "sha256-aMgUwgKHgR+NQvRxiUV7GaXehjDIlJJJHwSmHDmzK08=";
  };

  propagatedBuildInputs = [
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
    changelog = "https://github.com/RogerSelwyn/skyq_remote/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
