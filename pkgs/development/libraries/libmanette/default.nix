{ lib, stdenv
, fetchurl
, ninja
, meson
, mesonEmulatorHook
, pkg-config
, vala
, gobject-introspection
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, glib
, libgudev
, libevdev
, gnome
}:

stdenv.mkDerivation rec {
  pname = "libmanette";
  version = "0.2.6";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1b3bcdkk5xd5asq797cch9id8692grsjxrc1ss87vv11m1ck4rb3";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    gobject-introspection
    glib
    libgudev
    libevdev
  ];

  mesonFlags = [
    "-Ddoc=true"
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "A simple GObject game controller library";
    homepage = "https://gnome.pages.gitlab.gnome.org/libmanette/";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
