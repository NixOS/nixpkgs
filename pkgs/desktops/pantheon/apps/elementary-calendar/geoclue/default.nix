{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, intltool
, meson
, ninja
, pkg-config
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_412
, glib
, json-glib
, libsoup_3
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
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-TbuO9wpyjtvyvqaCryaTOunR0hVVlJuqENWQQpcMcz4=";
  };

  patches = [
    # Port to libsoup_3
    # https://gitlab.freedesktop.org/geoclue/geoclue/-/merge_requests/129
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/geoclue/geoclue/-/commit/9c46c38096193988103bf4c2fa63d76b55e5b1d0.patch";
      sha256 = "sha256-2VgvPcOb19dJ9tJc/TeS2/5OsUFeuYAZ/YF/4Dg7tgs=";
    })

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
    libsoup_3
    avahi
  ] ++ lib.optionals withDemoAgent [
    libnotify
    gdk-pixbuf
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
    broken = stdenv.isDarwin;
    description = "Geolocation framework and some data providers";
    homepage = "https://gitlab.freedesktop.org/geoclue/geoclue/wikis/home";
    maintainers = with maintainers; [ raskin ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.lgpl2;
  };
}
