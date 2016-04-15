{ stdenv, intltool, fetchurl, libxml2, upower
, pkgconfig, gtk3, glib, dconf
, bash, wrapGAppsHook, itstool, vala, sqlite, libxslt
, gnome3, librsvg, gdk_pixbuf, file, libnotify
, evolution_data_server, gst_all_1, poppler
, icu, taglib, libjpeg, libtiff, giflib, libcue
, libvorbis, flac, exempi, networkmanager
, libpng, libexif, libgsf, libuuid, bzip2 }:

let
  majorVersion = "1.8";
in
stdenv.mkDerivation rec {
  name = "tracker-${majorVersion}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/tracker/${majorVersion}/${name}.tar.xz";
    sha256 = "0zchaahk4w7dwanqk1vx0qgnyrlzlp81krwawfx3mv5zffik27x1";
  };

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = [ vala gtk3 glib dconf intltool itstool libxml2
                  bzip2 gnome3.totem-pl-parser libxslt
                  gnome3.gsettings_desktop_schemas wrapGAppsHook file
                  gdk_pixbuf gnome3.defaultIconTheme librsvg sqlite
                  upower libnotify evolution_data_server gnome3.libgee
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base flac
                  poppler icu taglib libjpeg libtiff giflib libvorbis
                  exempi networkmanager libpng libexif libgsf libuuid ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0 -I${poppler.dev}/include/poppler";

  enableParallelBuilding = true;

  preConfigure = ''
    substituteInPlace src/libtracker-sparql/Makefile.in \
      --replace "--shared-library=libtracker-sparql" "--shared-library=$out/lib/libtracker-sparql"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Tracker;
    description = "Desktop-neutral user information store, search tool and indexer";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
