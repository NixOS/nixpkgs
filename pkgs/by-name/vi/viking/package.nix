{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  desktopToDarwinBundle,
  docbook_xml_dtd_45,
  docbook_xsl,
  intltool,
  itstool,
  libxslt,
  pkg-config,
  wrapGAppsHook3,
  yelp-tools,
  curl,
  gdk-pixbuf,
  gtk3,
  json-glib,
  libxml2,
  gpsbabel,
  withGeoClue ? true,
  geoclue2,
  withGeoTag ? true,
  gexiv2,
  withMagic ? true,
  file,
  withMapnik ? false,
  mapnik,
  withMBTiles ? true,
  sqlite,
  withMd5Hash ? true,
  nettle,
  withOAuth ? true,
  liboauth,
  withRealtimeGPSTracking ? (!stdenv.hostPlatform.isDarwin),
  gpsd,
}:

stdenv.mkDerivation rec {
  pname = "viking";
  version = "1.10";

  src = fetchurl {
    url = "mirror://sourceforge/viking/viking-${version}.tar.bz2";
    sha256 = "sha256-lFXIlfmLwT3iS9ayNM0PHV7NwbBotMvG62ZE9hJuRaw=";
  };

  patches = [
    # Fix check_md5_hash.sh on macOS
    (fetchpatch {
      url = "https://github.com/viking-gps/viking/pull/184/commits/b0e110a3cfefea0f1874669525eb3a220dd29f9f.patch";
      hash = "sha256-HdkcZMV570SXOQMIZZAti2HT0gIdF/EwQCVXBaOwpqs=";
    })
  ];

  nativeBuildInputs = [
    docbook_xml_dtd_45
    docbook_xsl
    intltool
    itstool
    libxslt
    pkg-config
    wrapGAppsHook3
    yelp-tools
  ] ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  buildInputs =
    [
      curl
      gdk-pixbuf
      gtk3
      json-glib
      libxml2
    ]
    ++ lib.optional withGeoClue geoclue2
    ++ lib.optional withGeoTag gexiv2
    ++ lib.optional withMagic file
    ++ lib.optional withMapnik mapnik
    ++ lib.optional withMBTiles sqlite
    ++ lib.optional withMd5Hash nettle
    ++ lib.optional withOAuth liboauth
    ++ lib.optional withRealtimeGPSTracking gpsd;

  configureFlags = [
    (lib.enableFeature withGeoClue "geoclue")
    (lib.enableFeature withGeoTag "geotag")
    (lib.enableFeature withMagic "magic")
    (lib.enableFeature withMapnik "mapnik")
    (lib.enableFeature withMBTiles "mbtiles")
    (lib.enableFeature withMd5Hash "nettle")
    (lib.enableFeature withOAuth "oauth")
    (lib.enableFeature withRealtimeGPSTracking "realtime-gps-tracking")
  ];

  hardeningDisable = [ "format" ];

  doCheck = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ gpsbabel ]}
    )
  '';

  meta = with lib; {
    description = "GPS data editor and analyzer";
    mainProgram = "viking";
    longDescription = ''
      Viking is a free/open source program to manage GPS data.  You
      can import and plot tracks and waypoints, show Openstreetmaps
      and/or Terraserver maps under it, download geocaches for an area
      on the map, make new tracks and waypoints, see real-time GPS
      position, etc.
    '';
    homepage = "https://sourceforge.net/projects/viking/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      pSub
      sikmir
    ];
    platforms = with platforms; unix;
  };
}
