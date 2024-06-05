{ stdenv, lib, fetchFromGitHub, fetchpatch, python3Packages, installShellFiles }:

stdenv.mkDerivation rec {
  version = "1.6.0-unstable-2021-08-02";
  pname = "arduino-mk";

  src = fetchFromGitHub {
    owner  = "sudar";
    repo   = "Arduino-Makefile";
    rev    = "a1fbda0c53a75862bd7ac6285b70103ed04f70a6";
    sha256 = "sha256-sXFTkPv15RRzBna8eXeDjTYxLCDBiqBYqS2luwXN4kI=";
  };

  patches = [
    # removes grep warnings - https://github.com/sudar/Arduino-Makefile/pull/678
    (fetchpatch {
      url = "https://github.com/sudar/Arduino-Makefile/pull/678/commits/b03ad3402f556296bfddbbe3fb5ae0db6a886dce.patch";
      sha256 = "sha256-CzXbvoZAS4DRqrgQU59zgrIw6I0bda72S0N9f1MDmq8=";
    })
  ];

  nativeBuildInputs = [ python3Packages.wrapPython installShellFiles ];
  propagatedBuildInputs = with python3Packages; [ pyserial ];
  installPhase = ''
    mkdir $out
    cp -rT . $out
    installManPage *.1
  '';
  postFixupPhase = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Makefile for Arduino sketches";
    homepage = "https://github.com/sudar/Arduino-Makefile";
    license = licenses.lgpl21;
    maintainers = [ maintainers.eyjhb ];
    platforms = platforms.unix;
  };
}
