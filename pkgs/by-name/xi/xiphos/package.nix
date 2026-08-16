{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream,
  biblesync,
  cmake,
  desktop-file-utils,
  docbook2x,
  docbook_xml_dtd_412,
  glib,
  icu,
  intltool,
  itstool,
  libuuid,
  libxslt,
  minizip,
  pkg-config,
  speechd-minimal,
  sword,
  webkitgtk_4_1,
  wrapGAppsHook3,
  yelp-tools,
  zip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xiphos";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "crosswire";
    repo = "xiphos";
    tag = finalAttrs.version;
    hash = "sha256-csbhlYSn/TFxZV/pGHgJT4Hnqa26BZQUKD/CBHhxi/U=";
  };

  nativeBuildInputs = [
    appstream
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
    glib
    icu
    libuuid
    minizip
    speechd-minimal
    sword
    webkitgtk_4_1
  ];

  cmakeFlags = [
    "-DGTKTVEDITOR=ON"
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
