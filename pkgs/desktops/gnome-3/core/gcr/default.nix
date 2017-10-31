{ stdenv, fetchurl, pkgconfig, intltool, gnupg, p11_kit, glib
, libgcrypt, libtasn1, dbus_glib, gtk, pango, gdk_pixbuf, atk
, gobjectIntrospection, makeWrapper, libxslt, vala_0_32, gnome3 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = let
    gpg = gnupg.override { guiSupport = false; }; # prevent build cycle with pinentry_gnome
  in [
    intltool gpg gobjectIntrospection libxslt
    libgcrypt libtasn1 dbus_glib pango gdk_pixbuf atk makeWrapper vala_0_32
  ];

  propagatedBuildInputs = [ glib gtk p11_kit ];

  #doCheck = true;

  #enableParallelBuilding = true; issues on hydra

  preFixup = ''
    wrapProgram "$out/bin/gcr-viewer" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
