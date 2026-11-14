{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitea,
  fetchpatch2,
  setuptools,
  setuptools-scm,
  pyusb,
  asciimatics,
  pysnmp,
  zeroconf,
}:

buildPythonPackage {
  pname = "reinkpy";
  version = "2.260405.0"; # The proper version would be 2.240918.1-unstable-2026-04-05 but then the package no longer compiles
  pyproject = true;
  disabled = pythonOlder "3.11";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "atufi";
    repo = "reinkpy";
    rev = "4ae04caa82cdd1dbbf037dd96a5d2f89ec2212cb";
    hash = "sha256-/OmUy9Lpbv633iUHTXAoJ/i0ioO8IRfKQynIeq32x9A=";
  };

  __structuredAttrs = true;

  patches = [
    # Fix compatibility with newer Python versions, see https://codeberg.org/atufi/reinkpy/pulls/78
    (fetchpatch2 {
      url = "https://codeberg.org/atufi/reinkpy/pulls/78.patch";
      hash = "sha256-ICYeiFZtkLLa5UWSFXV+gqhfcR5AF7v70QXvcx5SH8U=";
    })
  ];

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
