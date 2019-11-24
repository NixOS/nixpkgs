{ stdenv
, fetchurl
, pkgconfig
, gettext
, gnupg
, p11-kit
, glib
, libgcrypt
, libtasn1
, gtk3
, pango
, gobject-introspection
, makeWrapper
, libxslt
, vala
, gnome3
, python3
}:

stdenv.mkDerivation rec {
  pname = "gcr";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0925snsixzkwh49xiayqmj6fcrmklqk8kyy0jkv7m64h9abm1pr9";
  };

  postPatch = ''
    patchShebangs build/ gcr/fixtures/
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkgconfig
    gettext
    gobject-introspection
    libxslt
    makeWrapper
    vala
  ];

  buildInputs = [
    gnupg
    libgcrypt
    libtasn1
    pango
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    p11-kit
  ];

  checkInputs = [
    python3
  ];

  doCheck = false; # fails 21 out of 603 tests, needs dbus daemon

  enableParallelBuilding = true;

  preFixup = ''
    wrapProgram "$out/bin/gcr-viewer" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    description = "GNOME crypto services (daemon and tools)";
    homepage = "https://gitlab.gnome.org/GNOME/gcr";
    license = licenses.lgpl2Plus;

    longDescription = ''
      GCR is a library for displaying certificates, and crypto UI, accessing
      key stores. It also provides the viewer for crypto files on the GNOME
      desktop.

      GCK is a library for accessing PKCS#11 modules like smart cards, in a
      (G)object oriented way.
    '';
  };
}
