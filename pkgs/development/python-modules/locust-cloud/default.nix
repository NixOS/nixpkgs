{
  lib,
  buildPythonPackage,
  configargparse,
  fetchFromGitHub,
  gevent,
  hatch-vcs,
  hatchling,
  platformdirs,
  python-engineio,
  python-socketio,
  requests,
  tomli,
}:

buildPythonPackage rec {
  pname = "locust-cloud";
  version = "1.27.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "locustcloud";
    repo = "locust-cloud";
    tag = version;
    hash = "sha256-jKCDbnVyL7K7w4mFIe4axKXcOKQgFPIPmVHDhxlzpsM=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    configargparse
    gevent
    platformdirs
    python-engineio
    python-socketio
    requests
    tomli
  ];

  pythonImportsCheck = [ "locust_cloud" ];

  meta = {
    description = "Hosted version of Locust to run distributed load tests";
    homepage = "https://github.com/locustcloud/locust-cloud";
    changelog = "https://github.com/locustcloud/locust-cloud/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ magicquark ];
  };
}
