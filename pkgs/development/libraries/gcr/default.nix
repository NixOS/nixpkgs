{ stdenv, fetchurl, pkgconfig, gettext, gnupg, p11-kit, glib
, libgcrypt, libtasn1, dbus-glib, gtk3, pango, gdk-pixbuf, atk
, gobject-introspection, makeWrapper, libxslt, vala, gnome3
, python3 }:

stdenv.mkDerivation rec {
  pname = "gcr";
  version = "3.33.4";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1hf06p4qfyywnb6334ysnr6aqxik3srb37glclvr4yhb3wzrjqnm";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = pname; };
  };

  postPatch = ''
    patchShebangs .
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig gettext gobject-introspection libxslt makeWrapper vala ];

  buildInputs = [ gnupg libgcrypt libtasn1 dbus-glib pango gdk-pixbuf atk ];

  propagatedBuildInputs = [ glib gtk3 p11-kit ];

  checkInputs = [ python3 ];
  doCheck = false; # fails 21 out of 603 tests, needs dbus daemon

  #enableParallelBuilding = true; issues on hydra

  preFixup = ''
    wrapProgram "$out/bin/gcr-viewer" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    description = "GNOME crypto services (daemon and tools)";
    homepage    = https://gitlab.gnome.org/GNOME/gcr;
    license     = licenses.gpl2;

    longDescription = ''
      GCR is a library for displaying certificates, and crypto UI, accessing
      key stores. It also provides the viewer for crypto files on the GNOME
      desktop.

      GCK is a library for accessing PKCS#11 modules like smart cards, in a
      (G)object oriented way.
    '';
  };
}
