{ lib, stdenv, fetchurl, pkg-config, pure, lilv, lv2, serd, sord, sratom }:

stdenv.mkDerivation rec {
  pname = "pure-lilv";
  version = "0.4";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-lilv-${version}.tar.gz";
    sha256 = "af20982fe43e8dce62d50bf7a78e461ab36c308325b123cddbababf0d3beaf9f";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure lilv lv2 serd sord sratom ];
  makeFlags = [ "CFLAGS=-I${lilv}/include/lilv-0" "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A Pure module for David Robillard’s Lilv, a library for LV2 plugin host writers";
    homepage = "http://puredocs.bitbucket.org/pure-lilv.html";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
