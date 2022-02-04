{ lib, stdenv, fetchurl, pkg-config, pure, faust, libtool }:

stdenv.mkDerivation rec {
  pname = "pure-faust";
  version = "0.11";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-faust-${version}.tar.gz";
    sha256 = "51278a3b0807c4770163dc2ce423507dcf0ffec9cd1c1fbc08426d07294f6ae0";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure faust libtool ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "Lets you load and run Faust-generated signal processing modules in Pure";
    homepage = "http://puredocs.bitbucket.org/pure-faust.html";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
