{ lib
, stdenv
, fetchurl
, autoreconfHook
, gtk2-x11
, librep
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rep-gtk";
  version = "0.90.8.3";

  src = fetchurl {
    url = "https://download.tuxfamily.org/librep/rep-gtk/rep-gtk_${finalAttrs.version}.tar.xz";
    hash = "sha256-qWV120V5Tu/QVkFylno47y1/7DriZExHjp99VLmf80E=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    librep
  ];

  buildInputs = [
    gtk2-x11
    librep
  ];

  strictDeps = true;

  patchPhase = ''
    sed -e 's|installdir=$(repexecdir)|installdir=$(libdir)/rep|g' -i Makefile.in
  '';

  meta = {
    homepage = "http://sawfish.tuxfamily.org";
    description = "GTK bindings for librep";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
# TODO: investigate fetchFromGithub
