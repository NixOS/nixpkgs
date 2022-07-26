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
    # Fix for falling back to GeoIP when WiFi devices are not found
    # https://gitlab.freedesktop.org/geoclue/geoclue/-/commit/2de651b6590087a2df2defe8f3d85b3cf6b91494
    # NOTE: this should be removed when the next version is released
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/geoclue/geoclue/commit/2de651b6590087a2df2defe8f3d85b3cf6b91494.patch";
      sha256 = "hv7t2Hmpv2oDXiPWA7JpYD9q+cuuk+En/lJJickvFII=";
    })

    # Make the Mozilla API key configurable
    # https://gitlab.freedesktop.org/geoclue/geoclue/merge_requests/54 (only partially backported)
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/geoclue/geoclue/commit/95c9ad4dc176860c85a07d0db4cb4179929bdb54.patch";
      sha256 = "/lq/dLBJl2vf16tt7emYoTtXY6iUw+4s2XcABUHp3Kc=";
    })
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/geoclue/geoclue/commit/1a00809a0d89b0849a57647c878d192354247a33.patch";
      sha256 = "6FuiukgFWg2cEKt8LlKP4E0rfSH/ZQgk6Ip1mGJpNFQ=";
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
