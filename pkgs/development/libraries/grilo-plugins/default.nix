{ stdenv
, fetchurl
, substituteAll
, meson
, ninja
, pkgconfig
, gettext
, gperf
, sqlite
, librest
, libarchive
, libsoup
, gnome3
, libxml2
, lua5_3
, liboauth
, libgdata
, libmediaart
, grilo
, gst_all_1
, gnome-online-accounts
, gmime
, gom
, json-glib
, avahi
, tracker
, dleyna-server
, itstool
, totem-pl-parser
}:

stdenv.mkDerivation rec {
  pname = "grilo-plugins";
  version = "0.3.10";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0jldaixc4kzycn5v8ixkjld1n0z3dp0l1p3vchgdwpvdvc7kcfw0";
  };

  patches = [
    # grl-chromaprint requires the following GStreamer elements:
    # * fakesink (gstreamer)
    # * playbin (gst-plugins-base)
    # * chromaprint (gst-plugins-bad)
    (substituteAll {
      src = ./chromaprint-gst-plugins.patch;
      load_plugins = stdenv.lib.concatMapStrings (plugin: ''gst_registry_scan_path(gst_registry_get(), "${plugin}/lib/gstreamer-1.0");'') (with gst_all_1; [
        gstreamer
        gst-plugins-base
        gst-plugins-bad
      ]);
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gettext
    itstool
    gperf # for lua-factory
  ];

  buildInputs = [
    grilo
    libxml2
    libgdata
    lua5_3
    liboauth
    sqlite
    gnome-online-accounts
    totem-pl-parser
    librest
    libarchive
    libsoup
    gmime
    gom
    json-glib
    avahi
    libmediaart
    tracker
    dleyna-server
    gst_all_1.gstreamer
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Grilo;
    description = "A collection of plugins for the Grilo framework";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
