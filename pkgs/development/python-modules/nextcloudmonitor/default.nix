{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "nextcloudmonitor";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meichthys";
    repo = "nextcloud_monitor";
    tag = "v${version}";
    hash = "sha256-748cDMxPjOQFKdSt1GrQqZHmPgz20HN1+lMzo2vMj6c=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "nextcloudmonitor" ];

  meta = {
    changelog = "https://github.com/meichthys/nextcloud_monitor/blob/${src.tag}/README.md#change-log";
    description = "Python wrapper around nextcloud monitor api";
    homepage = "https://github.com/meichthys/nextcloud_monitor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
