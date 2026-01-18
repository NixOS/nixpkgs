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
  version = "2026.01.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frostming";
    repo = "pbs-installer";
    tag = version;
    hash = "sha256-wyO5Knjo/FmWl/SMC6K2wPwQI2tVz7bfyD7Pl1yeFkk=";
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
