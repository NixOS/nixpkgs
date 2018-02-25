{ stdenv, fetchurl, pkgconfig, intltool, gnupg, p11-kit, glib
, libgcrypt, libtasn1, dbus-glib, gtk, pango, gdk_pixbuf, atk
, gobjectIntrospection, makeWrapper, libxslt, vala, gnome3 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig intltool gobjectIntrospection libxslt makeWrapper vala ];

  buildInputs = let
    gpg = gnupg.override { guiSupport = false; }; # prevent build cycle with pinentry_gnome
  in [
    gpg libgcrypt libtasn1 dbus-glib pango gdk_pixbuf atk
  ];

  propagatedBuildInputs = [ glib gtk p11-kit ];

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
