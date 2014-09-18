{ stdenv, fetchurl, pkgconfig, e19 }:
stdenv.mkDerivation rec {
  name = "terminology-${version}";
  version = "0.6.1";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/terminology/${name}.tar.gz";
    sha256 = "1wi9njyfs95y4nb9jd30032qqka5cg7k0wacck8s1yqxwg5ng38x";
  };
  buildInputs = [ pkgconfig e19.efl e19.elementary ];
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="-I${e19.efl}/include/eo-1 $NIX_CFLAGS_COMPILE"
    export NIX_CFLAGS_COMPILE="-I${e19.efl}/include/ecore-con-1 $NIX_CFLAGS_COMPILE"
    export NIX_CFLAGS_COMPILE="-I${e19.efl}/include/eldbus-1 $NIX_CFLAGS_COMPILE"
    export NIX_CFLAGS_COMPILE="-I${e19.efl}/include/ethumb-1 $NIX_CFLAGS_COMPILE"
  '';
  meta = {
    description = "The best terminal emulator written with the EFL";
    homepage = http://enlightenment.org/;
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
  };
}
