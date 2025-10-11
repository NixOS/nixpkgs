{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitea,
  setuptools,
  setuptools-scm,
  pyusb,
  asciimatics,
  pysnmp,
  zeroconf,
}:

buildPythonPackage {
  pname = "reinkpy";
  version = "2.250428.0"; # The proper version would be 2.240918.1-unstable-2025-04-28 but then the package no longer compiles
  pyproject = true;
  disabled = pythonOlder "3.11";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "atufi";
    repo = "reinkpy";
    rev = "101e90e35b589bdab92a9f5a0cf81f1358dbd109";
    hash = "sha256-6GNi5bmCA62ZYc96EF0p2bD1jyFm18pktv3THQfkovE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    # USB
    pyusb

    # UI
    asciimatics

    # Network (not working, see longDescription below)
    pysnmp
    zeroconf
  ];

  pythonImportsCheck = [ "reinkpy" ];

  strictDeps = true;

  meta = with lib; {
    description = "Waste ink counter resetter for some (EPSON) printers";
    longDescription = ''
      Note that the networking portion of this package does not work currently, as Nixpkgs has incompatible versions of some libraries.
      See https://codeberg.org/atufi/reinkpy/issues/29 and https://codeberg.org/atufi/reinkpy/issues/27 for two issues that are caused by this.
      This should be fixed, once https://codeberg.org/atufi/reinkpy/issues/28 has been closed.
    '';
    homepage = "https://codeberg.org/atufi/reinkpy";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ Luflosi ];
  };
}
