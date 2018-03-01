{ stdenv, fetchurl, pkgconfig, intltool, gnupg, p11-kit, glib
, libgcrypt, libtasn1, dbus-glib, gtk, pango, gdk_pixbuf, atk
, gobjectIntrospection, makeWrapper, libxslt, vala, gnome3 }:

stdenv.mkDerivation rec {
  name = "gcr-${version}";
  version = "3.20.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gcr/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "90572c626d8a708225560c42b4421f7941315247fa1679d4ef569bde7f4bb379";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gcr"; attrPath = "gnome3.gcr"; };
  };

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
