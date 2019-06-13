{ stdenv, fetchurl, pkgconfig, intltool, gnupg, p11-kit, glib
, libgcrypt, libtasn1, dbus-glib, gtk3, pango, gdk_pixbuf, atk
, gobject-introspection, makeWrapper, libxslt, vala, gnome3
, python2 }:

stdenv.mkDerivation rec {
  pname = "gcr";
  version = "3.28.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "12qn7mcmxb45lz1gq3s3b34rimiyrrshkrpvxdw1fc0w26i4l84m";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = pname; };
  };

  postPatch = ''
    patchShebangs .
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig intltool gobject-introspection libxslt makeWrapper vala ];

  buildInputs = let
    gpg = gnupg.override { guiSupport = false; }; # prevent build cycle with pinentry_gnome
  in [
    gpg libgcrypt libtasn1 dbus-glib pango gdk_pixbuf atk
  ];

  propagatedBuildInputs = [ glib gtk3 p11-kit ];

  checkInputs = [ python2 ];
  doCheck = false; # fails 21 out of 603 tests, needs dbus daemon

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
