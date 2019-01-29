{ stdenv, fetchFromGitLab, intltool, meson, ninja, pkgconfig, gtk-doc, docbook_xsl, docbook_xml_dtd_412, glib, json-glib, libsoup, libnotify, gdk_pixbuf
, modemmanager, avahi, glib-networking, python3, wrapGAppsHook, gobject-introspection, vala
, withDemoAgent ? false
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "geoclue-${version}";
  version = "2.5.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "geoclue";
    repo = "geoclue";
    rev = version;
    sha256 = "0vww6irijw5ss7vawkdi5z5wdpcgw4iqljn5vs3vbd4y3d0lzrbs";
  };

  patches = [
    ./add-option-for-installation-sysconfdir.patch
  ];

  outputs = [ "out" "dev" "devdoc" ];

  nativeBuildInputs = [
    pkgconfig intltool meson ninja wrapGAppsHook python3 vala gobject-introspection
    # devdoc
    gtk-doc docbook_xsl docbook_xml_dtd_412
  ];

  buildInputs = [
    glib json-glib libsoup avahi
  ] ++ optionals withDemoAgent [
    libnotify gdk_pixbuf
  ] ++ optionals (!stdenv.isDarwin) [ modemmanager ];

  propagatedBuildInputs = [ glib glib-networking ];

  mesonFlags = [
    "-Dsystemd-system-unit-dir=${placeholder "out"}/etc/systemd/system"
    "-Ddemo-agent=${if withDemoAgent then "true" else "false"}"
    "--sysconfdir=/etc"
    "-Dsysconfdir_install=${placeholder "out"}/etc"
  ] ++ optionals stdenv.isDarwin [
    "-D3g-source=false"
    "-Dcdma-source=false"
    "-Dmodem-gps-source=false"
    "-Dnmea-source=false"
  ];

  postPatch = ''
    chmod +x demo/install-file.py
    patchShebangs demo/install-file.py
  '';

  meta = with stdenv.lib; {
    description = "Geolocation framework and some data providers";
    homepage = https://gitlab.freedesktop.org/geoclue/geoclue/wikis/home;
    maintainers = with maintainers; [ raskin garbas ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.lgpl2;
  };
}
