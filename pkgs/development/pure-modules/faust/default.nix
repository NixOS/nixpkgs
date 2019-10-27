{ stdenv, fetchurl, pkgconfig, pure, faust, libtool }:

stdenv.mkDerivation rec {
  baseName = "faust";
  version = "0.11";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "51278a3b0807c4770163dc2ce423507dcf0ffec9cd1c1fbc08426d07294f6ae0";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure faust libtool ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "Lets you load and run Faust-generated signal processing modules in Pure";
    homepage = http://puredocs.bitbucket.org/pure-faust.html;
    license = stdenv.lib.licenses.lgpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
