{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pdm-backend
, httpx
, zstandard
}:

buildPythonPackage rec {
  pname = "pbs-installer";
  version = "2024.4.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "frostming";
    repo = "pbs-installer";
    rev = version;
    hash = "sha256-0LuajPD/sM0LoyRoCkGJ9medUcWNEPqvY76GgK2rIac=";
  };

  build-system = [
    pdm-backend
  ];

  optional-dependencies = {
    all = optional-dependencies.install ++ optional-dependencies.download;
    download = [
      httpx
    ];
    install = [
      zstandard
    ];
  };

  pythonImportsCheck = [ "pbs_installer" ];

  # upstream has no test
  doCheck = false;

  meta = with lib; {
    description = "Installer for Python Build Standalone";
    homepage = "https://github.com/frostming/pbs-installer";
    changelog = "https://github.com/frostming/pbs-installer/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
