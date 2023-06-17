{ stdenv, lib, fetchFromGitHub, python3Packages, installShellFiles }:

stdenv.mkDerivation rec {
  version = "1.6.0";
  pname = "arduino-mk";

  src = fetchFromGitHub {
    owner  = "sudar";
    repo   = "Arduino-Makefile";
    rev    = version;
    sha256 = "0flpl97d2231gp51n3y4qvf3y1l8xzafi1sgpwc305vwc2h4dl2x";
  };

  nativeBuildInputs = [ python3Packages.wrapPython installShellFiles ];
  propagatedBuildInputs = with python3Packages; [ pyserial ];
  installPhase = ''
    mkdir $out
    cp -rT $src $out
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
