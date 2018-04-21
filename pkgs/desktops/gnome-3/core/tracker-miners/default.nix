{ stdenv, intltool, fetchurl, libxml2, upower
, substituteAll, pkgconfig, gtk3, glib, gexiv2
, bash, wrapGAppsHook, itstool, vala, sqlite, libxslt
, gnome3, librsvg, gdk_pixbuf, libnotify
, evolution-data-server, gst_all_1, poppler
, icu, taglib, libjpeg, libtiff, giflib, libcue
, libvorbis, flac, exempi, networkmanager
, libpng, libexif, libgsf, libuuid, bzip2
, libsoup, json-glib, libseccomp
, libiptcdata }:

let
  pname = "tracker-miners";
  version = "2.0.4";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0mp9m2waii583sjgr61m1ni6py6dry11r0rzidgvw1g4cxhn89j6";
  };

  NIX_CFLAGS_COMPILE = "-I${poppler.dev}/include/poppler";

  enableParallelBuilding = true;

  nativeBuildInputs = [ vala pkgconfig intltool itstool libxslt wrapGAppsHook ];
  # TODO: add libgrss, libenca, libosinfo
  buildInputs = [
    bzip2 evolution-data-server exempi flac giflib glib gnome3.totem-pl-parser
    gnome3.tracker gst_all_1.gst-plugins-base gst_all_1.gstreamer icu
    json-glib libcue libexif libgsf libiptcdata libjpeg libpng libseccomp libsoup
    libtiff libuuid libvorbis libxml2 poppler taglib upower gexiv2
  ];

  LANG = "en_US.UTF-8"; # for running tests

  doCheck = true;

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit (gnome3) tracker;
    })
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Tracker;
    description = "Desktop-neutral user information store, search tool and indexer";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
