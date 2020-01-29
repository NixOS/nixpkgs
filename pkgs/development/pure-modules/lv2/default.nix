{ stdenv, fetchurl, pkgconfig, pure, lv2 }:

stdenv.mkDerivation rec {
  baseName = "lv2";
  version = "0.2";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "721cacd831781d8309e7ecabb0ee7c01da17e75c5642a5627cf158bfb36093e1";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure lv2 ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A generic LV2 plugin wrapper for Pure which can be linked with batch-compiled Pure scripts to obtain LV2 plugin modules";
    homepage = http://puredocs.bitbucket.org/pure-lv2.html;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
