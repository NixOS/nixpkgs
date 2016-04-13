{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.8-beta";
  name = "nanomsg-${version}";

  src = fetchurl {
    url = "https://github.com/nanomsg/nanomsg/releases/download/0.8-beta/${name}.tar.gz";
    sha256 = "0ix9yd6shqmgm1mxig8ww2jpbgg2n5dms0wrv1q81ihclml0rkkm";
  };

  installPhase = ''
    mkdir -p "$out"
    make install PREFIX="$out"
  '';

  meta = with stdenv.lib; {
    description= "Socket library that provides several common communication patterns";
    homepage = http://nanomsg.org/;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
