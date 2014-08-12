{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.4-beta";
  name = "nanomsg-${version}";

  src = fetchurl {
    url = "http://download.nanomsg.org/${name}.tar.gz";
    sha256 = "0bgjj1x1a991pckw4nm5bkmbibjsf74y0ns23fpk4jj5dwarhm3d";
  };

  installPhase = ''
    mkdir -p "$out"
    make install PREFIX="$out"
  '';

  meta = with stdenv.lib; {
    description= "Socket library that provides several common communication patterns";
    homepage = http://nanomsg.org/;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
