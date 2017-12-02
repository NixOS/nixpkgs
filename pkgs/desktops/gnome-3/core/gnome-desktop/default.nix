{ stdenv, fetchurl, pkgconfig, python, libxml2Python, libxslt, which, libX11, gnome3, gtk3, glib
, intltool, gnome_doc_utils, libxkbfile, xkeyboard_config, isocodes, itstool, wayland
, libseccomp, bubblewrap, gobjectIntrospection }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  # this should probably be setuphook for glib
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkgconfig which itstool intltool libxslt gnome_doc_utils gobjectIntrospection
  ];
  buildInputs = [ python libxml2Python libX11 bubblewrap
                  xkeyboard_config isocodes wayland
                  gtk3 glib libxkbfile libseccomp ];

  propagatedBuildInputs = [ gnome3.gsettings_desktop_schemas ];

  patches = [
    ./bubblewrap-paths.patch
  ];

  postPatch = ''
    substituteInPlace libgnome-desktop/gnome-desktop-thumbnail-script.c --subst-var-by \
      BUBBLEWRAP_BIN "${bubblewrap}/bin/bwrap"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
