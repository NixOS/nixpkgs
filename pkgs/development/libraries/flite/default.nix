{ stdenv, fetchFromGitHub, alsaLib }:

stdenv.mkDerivation rec {
  pname = "flite";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "festvox";
    repo = "flite";
    rev = "v${version}";
    sha256 = "1n0p81jzndzc1rzgm66kw9ls189ricy5v1ps11y0p2fk1p56kbjf";
  };

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ alsaLib ];

  configureFlags = [
    "--enable-shared"
  ] ++ stdenv.lib.optionals stdenv.isLinux [ "--with-audio=alsa" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A small, fast run-time speech synthesis engine";
    homepage = "http://www.festvox.org/flite/";
    license = licenses.bsdOriginal;
    platforms = platforms.all;
  };
}
