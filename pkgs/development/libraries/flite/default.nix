{ stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "flite-1.4";

  src = fetchurl {
    url = "http://www.speech.cs.cmu.edu/flite/packed/${name}/${name}-release.tar.bz2";
    sha256 = "036dagsydi0qh71ayi6jshfi3ik2md1az3gpi42md9pc18b65ij5";
  };

  buildInputs = [ pkgconfig ];

  configureFlags = ''
    --enable-shared
  '';

  meta = {
    description = "A small, fast run-time speech synthesis engine";
    homepage = http://www.speech.cs.cmu.edu/flite/index.html; 
    license = "free-non-copyleft";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}

