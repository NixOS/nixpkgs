{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, smbus-cffi
, urwid
}:

buildPythonPackage rec {
  pname = "pijuice";
  version = "1.7";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "PiSupply";
    repo = "PiJuice";
    # Latest commit that fixes using the library against python 3.9 by renaming
    # isAlive() to is_alive(). The former function was removed in python 3.9.
    rev = "e2dca1f8dcfa12e009952a882c0674a545d193d6";
    sha256 = "07Jr7RSjqI8j0tT0MNAjrN1sjF1+mI+V0vtKInvtxj8=";
  };

  patches = [
    # The pijuice_cli.cli file doesn't have a shebang as the first line of the
    # script. Without it, the pythonWrapPrograms hook will not wrap the program.
    # Add a python shebang here so that the the hook is triggered.
    ./patch-shebang.diff
  ];

  PIJUICE_BUILD_BASE = 1;
  PIJUICE_VERSION = version;

  preBuild = ''
    cd Software/Source
  '';

  propagatedBuildInputs = [ smbus-cffi urwid ];

  # Remove the following files from the package:
  #
  # pijuice_cli - A precompiled ELF binary that is a setuid wrapper for calling
  #               pijuice_cli.py
  #
  # pijuiceboot - a precompiled ELF binary for flashing firmware. Not needed for
  #               the python library.
  #
  # pijuice_sys.py - A program that acts as a system daemon for monitoring the
  #                  pijuice.
  preFixup = ''
    rm $out/bin/pijuice_cli
    rm $out/bin/pijuice_sys.py
    rm $out/bin/pijuiceboot
    mv $out/bin/pijuice_cli.py $out/bin/pijuice_cli
  '';

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Library and resources for PiJuice HAT for Raspberry Pi";
    homepage = "https://github.com/PiSupply/PiJuice";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hexagonal-sun ];
  };
}
