{ lib
, stdenv
, fetchFromGitLab
, intltool
, meson
, ninja
, pkg-config
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_412
, glib
, json-glib
, libsoup
, libnotify
, gdk-pixbuf
, modemmanager
, avahi
, glib-networking
, python3
, wrapGAppsHook
, gobject-introspection
, vala
, withDemoAgent ? false
}:

stdenv.mkDerivation rec {
  pname = "geoclue";
  version = "2.5.7";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1mv1vs4q94bqkmgkj53jcsw1x31kczwydyy3r27a7fycgzmii1pj";
  };

  patches = [
    ./add-option-for-installation-sysconfdir.patch
  ];

  nativeBuildInputs = [
    pkg-config
    intltool
    meson
    ninja
    wrapGAppsHook
    python3
    vala
    gobject-introspection
    # devdoc
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_412
  ];

  buildInputs = [
    glib
    json-glib
    libsoup
    avahi
  ] ++ lib.optionals withDemoAgent [
    libnotify gdk-pixbuf
  ] ++ lib.optionals (!stdenv.isDarwin) [
    modemmanager
  ];

  propagatedBuildInputs = [
    glib
    glib-networking
  ];

  mesonFlags = [
    "-Dsystemd-system-unit-dir=${placeholder "out"}/etc/systemd/system"
    "-Ddemo-agent=${lib.boolToString withDemoAgent}"
    "--sysconfdir=/etc"
    "-Dsysconfdir_install=${placeholder "out"}/etc"
    "-Ddbus-srv-user=geoclue"
    "-Ddbus-sys-dir=${placeholder "out"}/share/dbus-1/system.d"
  ] ++ lib.optionals stdenv.isDarwin [
    "-D3g-source=false"
    "-Dcdma-source=false"
    "-Dmodem-gps-source=false"
    "-Dnmea-source=false"
  ];

  postPatch = ''
    chmod +x demo/install-file.py
    patchShebangs demo/install-file.py
  '';

  meta = with lib; {
    description = "Geolocation framework and some data providers";
    homepage = "https://gitlab.freedesktop.org/geoclue/geoclue/wikis/home";
    maintainers = with maintainers; [ raskin ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.lgpl2;
  };
}
