{ stdenv, fetchurl, pkgconfig, pure, lilv, lv2, serd, sord, sratom }:

stdenv.mkDerivation rec {
  baseName = "lilv";
  version = "0.4";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "af20982fe43e8dce62d50bf7a78e461ab36c308325b123cddbababf0d3beaf9f";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure lilv lv2 serd sord sratom ];
  makeFlags = [ "CFLAGS=-I${lilv}/include/lilv-0" "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A Pure module for David Robillard’s Lilv, a library for LV2 plugin host writers";
    homepage = http://puredocs.bitbucket.org/pure-lilv.html;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
