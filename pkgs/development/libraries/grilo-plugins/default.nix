{ lib, stdenv
, fetchurl
, substituteAll
, meson
, ninja
, pkg-config
, gettext
, gperf
, sqlite
, librest
, libarchive
, libsoup
, gnome
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
  version = "0.3.14";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "aGhEs07HOySTH/bMT2Az8AcpR6bbYKzcf7Pq8Velgcg=";
  };

  patches = [
    # grl-chromaprint requires the following GStreamer elements:
    # * fakesink (gstreamer)
    # * playbin (gst-plugins-base)
    # * chromaprint (gst-plugins-bad)
    (substituteAll {
      src = ./chromaprint-gst-plugins.patch;
      load_plugins = lib.concatMapStrings (plugin: ''gst_registry_scan_path(gst_registry_get(), "${lib.getLib plugin}/lib/gstreamer-1.0");'') (with gst_all_1; [
        gstreamer
        gst-plugins-base
        gst-plugins-bad
      ]);
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
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
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/Grilo";
    description = "A collection of plugins for the Grilo framework";
    maintainers = teams.gnome.members;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
