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
  version = "2025.09.18";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "frostming";
    repo = "pbs-installer";
    tag = version;
    hash = "sha256-bkqQa7wqNBkeDVTG4HIj8im4wljrPTG3IS2c20m+rzg=";
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
