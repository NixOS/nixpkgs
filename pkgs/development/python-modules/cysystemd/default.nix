{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  nix-update-script,

  setuptools,
  cython,
  systemdLibs,
}:

buildPythonPackage rec {
  pname = "cysystemd";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "cysystemd";
    tag = version;
    hash = "sha256-K2SlTRPuFRvKUlWovWrS1BrbSBUF5FOI3aNC0FiCNfI=";
  };

  build-system = [
    setuptools
  ];

  buildInputs = [
    systemdLibs
  ];

  dependencies = [
    cython
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "cysystemd"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Systemd wrapper using Cython";
    homepage = "https://github.com/mosquito/cysystemd";
    changelog = "https://github.com/mosquito/cysystemd/releases/tag/${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.tigergorilla2 ];
  };
}
