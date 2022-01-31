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
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "PiSupply";
    repo = "PiJuice";
    # rev hash retrieved from the latest modification on file Software/Source/VERSION, as this project
    # does not use Github tags facility
    rev = "3ba6719ab614a3dc7495d5d9c900dd4ea977c7e3";
    sha256 = "GoNN07YgVaktpeY5iYDbfpy5fxkU1x0V3Sb1hgGAQt4=";
  };

  patches = [
    # The pijuice_cli.cli file doesn't have a shebang as the first line of the
    # script. Without it, the pythonWrapPrograms hook will not wrap the program.
    # Add a python shebang here so that the the hook is triggered.
    ./patch-shebang.diff
  ];

  PIJUICE_BUILD_BASE = 1;

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

  meta = with lib; {
    description = "Library and resources for PiJuice HAT for Raspberry Pi";
    homepage = "https://github.com/PiSupply/PiJuice";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hexagonal-sun ];
  };
}
