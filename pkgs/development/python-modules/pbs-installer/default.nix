{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  httpx,
  zstandard,
}:

buildPythonPackage rec {
  pname = "pbs-installer";
  version = "2026.01.27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frostming";
    repo = "pbs-installer";
    tag = version;
    hash = "sha256-aQ/GuskXKBpc1H6vtaBA3hZiPKip/2Kev/hbMcB9Y1E=";
  };

  build-system = [ pdm-backend ];

  optional-dependencies = {
    all = optional-dependencies.install ++ optional-dependencies.download;
    download = [ httpx ];
    install = [ zstandard ];
  };

  pythonImportsCheck = [ "pbs_installer" ];

  # upstream has no test
  doCheck = false;

  meta = {
    description = "Installer for Python Build Standalone";
    homepage = "https://github.com/frostming/pbs-installer";
    changelog = "https://github.com/frostming/pbs-installer/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
