{ stdenv
, fetchurl
, pkgconfig
, meson
, ninja
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
, shared-mime-info
}:

stdenv.mkDerivation rec {
  pname = "gcr";
  version = "3.36.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "00b6bzpr8rj8mvj66r2273r417wg2y21m6n88mhkq9m22z8bxyda";
  };

  postPatch = ''
    patchShebangs build/ gcr/fixtures/

    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkgconfig
    meson
    python3
    ninja
    gettext
    gobject-introspection
    libxslt
    makeWrapper
    vala
    shared-mime-info
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

  mesonFlags = [
    "-Dgtk_doc=false"
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
