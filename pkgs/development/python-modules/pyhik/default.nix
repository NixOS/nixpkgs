{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pydispatcher,
  requests,
}:

buildPythonPackage rec {
  pname = "pyhik";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mezz64";
    repo = "pyHik";
    tag = version;
    hash = "sha256-GqBHmwzQsnVGK1M2kKV3lQ3s7tsudoxmLC7xxGH55E0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pydispatcher
    requests
  ];

  meta = with lib; {
    changelog = "https://github.com/mezz64/pyHik/releases/tag/${src.tag}";
    homepage = "https://github.com/mezz64/pyhik";
    platforms = platforms.unix;
    maintainers = with maintainers; [ seberm ];
    license = licenses.mit;
    description = "Python module aiming to expose common API events from a Hikvision IP camera or NVR.";
  };
}
