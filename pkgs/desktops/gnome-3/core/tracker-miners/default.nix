{ stdenv, intltool, fetchurl, libxml2, upower
, pkgconfig, gtk3, glib
, bash, wrapGAppsHook, itstool, vala, sqlite, libxslt
, gnome3, librsvg, gdk_pixbuf, libnotify
, evolution-data-server, gst_all_1, poppler
, icu, taglib, libjpeg, libtiff, giflib, libcue
, libvorbis, flac, exempi, networkmanager
, libpng, libexif, libgsf, libuuid, bzip2
, libsoup, json-glib, libseccomp
, libiptcdata }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  NIX_CFLAGS_COMPILE = "-I${poppler.dev}/include/poppler";

  enableParallelBuilding = true;

  nativeBuildInputs = [ vala pkgconfig intltool itstool libxslt wrapGAppsHook ];
  # TODO: add libgrss, libenca
  buildInputs = [
    bzip2 evolution-data-server exempi flac giflib glib gnome3.totem-pl-parser
    gnome3.tracker gst_all_1.gst-plugins-base gst_all_1.gstreamer icu
    json-glib libcue libexif libgsf libiptcdata libjpeg libpng libseccomp libsoup
    libtiff libuuid libvorbis libxml2 poppler taglib upower
  ];

  LANG = "en_US.UTF-8"; # for running tests

  doCheck = true;

  postPatch = ''
    substituteInPlace src/libtracker-common/tracker-domain-ontology.c --replace \
      'SHAREDIR, "tracker", "domain-ontologies"' \
      '"${gnome3.tracker}/share", "tracker", "domain-ontologies"'
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Tracker;
    description = "Desktop-neutral user information store, search tool and indexer";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
