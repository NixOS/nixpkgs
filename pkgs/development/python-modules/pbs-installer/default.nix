{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pdm-backend,
  httpx,
  zstandard,
}:

buildPythonPackage rec {
  pname = "pbs-installer";
  version = "2025.07.23";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "frostming";
    repo = "pbs-installer";
    tag = version;
    hash = "sha256-cQPQ5IDjTBTHwUU60w+gCcwTyiaC30DPIb96e0hOHIY=";
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

  meta = with lib; {
    description = "Installer for Python Build Standalone";
    homepage = "https://github.com/frostming/pbs-installer";
    changelog = "https://github.com/frostming/pbs-installer/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
