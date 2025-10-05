{
  buildPythonPackage,
  configargparse,
  fetchFromGitHub,
  gevent,
  hatch-vcs,
  hatchling,
  lib,
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

  meta = {
    description = "Hosted version of Locust to run distributed load tests";
    homepage = "https://www.locust.cloud/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ magicquark ];
  };
}
