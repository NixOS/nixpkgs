{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream-glib,
  biblesync,
  cmake,
  dbus-glib,
  desktop-file-utils,
  docbook2x,
  docbook_xml_dtd_412,
  glib,
  gtkhtml,
  icu,
  intltool,
  itstool,
  libuuid,
  libxslt,
  minizip,
  pkg-config,
  sword,
  webkitgtk_4_1,
  wrapGAppsHook3,
  yelp-tools,
  zip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xiphos";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner = "crosswire";
    repo = "xiphos";
    tag = finalAttrs.version;
    hash = "sha256-HTndBWfze8tV4G9npLYB7SkgpJNQcQBZqHKjxhZU6JY=";
  };

  patches = [
    # Fix D-Bus build
    # https://github.com/crosswire/xiphos/pull/1103
    ./0001-Add-dbus-glib-dependency-to-main.patch
  ];

  nativeBuildInputs = [
    appstream-glib # for appstream-util
    cmake
    desktop-file-utils # for desktop-file-validate
    docbook2x
    docbook_xml_dtd_412
    intltool
    itstool
    libxslt
    pkg-config
    wrapGAppsHook3
    yelp-tools # for yelp-build
    zip # for building help epubs
  ];

  buildInputs = [
    biblesync
    dbus-glib
    glib
    gtkhtml
    icu
    libuuid
    minizip
    sword
    webkitgtk_4_1
  ];

  cmakeFlags = [
    # WebKit-based editor does not build.
    "-DGTKHTML=ON"
  ];

  preConfigure = ''
    # The build script won't continue without the version saved locally.
    echo "${finalAttrs.version}" > cmake/source_version.txt

    export SWORD_HOME=${sword};
  '';

  meta = {
    description = "GTK Bible study tool";
    longDescription = ''
      Xiphos (formerly known as GnomeSword) is a Bible study tool
      written for Linux, UNIX, and Windows using GTK, offering a rich
      and featureful environment for reading, study, and research using
      modules from The SWORD Project and elsewhere.
    '';
    homepage = "https://www.xiphos.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
