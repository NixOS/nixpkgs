{ lib, stdenv, fetchurl, pkg-config, pure, pure-ffi, gtk2 }:

stdenv.mkDerivation rec {
  baseName = "gtk";
  version = "0.13";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "e659ff1bc5809ce35b810f8ac3fb7e8cadaaef13996537d8632e2f86ed76d203";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure pure-ffi gtk2 ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A collection of bindings to use the GTK GUI toolkit version 2.x with Pure";
    homepage = "http://puredocs.bitbucket.org/pure-gtk.html";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
