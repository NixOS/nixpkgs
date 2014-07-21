{ stdenv, fetchurl, pkgconfig, e18, xlibs, libffi, pam, alsaLib, luajit }:
stdenv.mkDerivation rec {
  name = "enlightenment-${version}";
  version = "0.18.8";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/enlightenment/${name}.tar.gz";
    sha256 = "1fsigbrknkwy909p1gqwxag1bar3p413s4f6fq3qnbsd6gjbvj8l";
  };
  buildInputs = [ pkgconfig e18.efl e18.elementary xlibs.libxcb xlibs.xcbutilkeysyms xlibs.libXrandr libffi pam alsaLib luajit ];
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="-I${e18.efl}/include/eo-1 -I${e18.efl}/include/ecore-imf-1 -I${e18.efl}/include/ethumb-client-1 -I${e18.efl}/include/ethumb-1 $NIX_CFLAGS_COMPILE"
  '';
  meta = {
    description = "The Compositing Window Manager and Desktop Shell";
    homepage = http://enlightenment.org/;
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
  };
}
