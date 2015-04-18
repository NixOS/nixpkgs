{ stdenv, fetchurl, pkgconfig, e19 }:
stdenv.mkDerivation rec {
  name = "terminology-${version}";
  version = "0.8.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/terminology/${name}.tar.gz";
    sha256 = "7a10d44b023cf6134c2483304e4ad33bea6df0f11266aec482f54fa67a3ce628";
  };
  buildInputs = [ pkgconfig e19.efl e19.elementary ];
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="-I${e19.efl}/include/eo-1 $NIX_CFLAGS_COMPILE"
    export NIX_CFLAGS_COMPILE="-I${e19.efl}/include/ecore-con-1 $NIX_CFLAGS_COMPILE"
    export NIX_CFLAGS_COMPILE="-I${e19.efl}/include/eldbus-1 $NIX_CFLAGS_COMPILE"
    export NIX_CFLAGS_COMPILE="-I${e19.efl}/include/ethumb-1 $NIX_CFLAGS_COMPILE"
    export NIX_CFLAGS_COMPILE="-I${e19.efl}/include/elocation-1 $NIX_CFLAGS_COMPILE"
  '';
  meta = {
    description = "The best terminal emulator written with the EFL";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
  };
}
