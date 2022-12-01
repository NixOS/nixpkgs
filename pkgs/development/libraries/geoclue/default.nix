{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, intltool
, meson
, mesonEmulatorHook
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
  version = "2.6.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "geoclue";
    repo = "geoclue";
    rev = version;
    hash = "sha256-TbuO9wpyjtvyvqaCryaTOunR0hVVlJuqENWQQpcMcz4=";
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
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    glib
    json-glib
    libsoup
    avahi
    gobject-introspection
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
    "-Dmozilla-api-key=5c28d1f4-9511-47ff-b11a-2bef80fc177c"
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
    broken = stdenv.isDarwin && withDemoAgent;
    description = "Geolocation framework and some data providers";
    homepage = "https://gitlab.freedesktop.org/geoclue/geoclue/wikis/home";
    maintainers = with maintainers; [ raskin ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.lgpl2Plus;
  };
}
