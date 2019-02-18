{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.6.0";
  name = "arduino-mk-${version}";

  src = fetchFromGitHub {
    owner  = "sudar";
    repo   = "Arduino-Makefile";
    rev    = "${version}";
    sha256 = "0flpl97d2231gp51n3y4qvf3y1l8xzafi1sgpwc305vwc2h4dl2x";
  };

  phases = ["installPhase"];
  installPhase = "ln -s $src $out";

  meta = {
    description = "Makefile for Arduino sketches";
    homepage = https://github.com/sudar/Arduino-Makefile;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.eyjhb ];
    platforms = stdenv.lib.platforms.unix;
  };
}

