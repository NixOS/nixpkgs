{ lib, stdenv
, fetchurl
, substituteAll
, meson
, ninja
, pkg-config
, gettext
, gperf
, sqlite
, libarchive
, libdmapsharing
, libsoup_3
, gnome
, libxml2
, lua5_4
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
  version = "0.3.16";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "/m9Nvlhsa4uiQGOU4gLyLQCdZCqW6zpU8y9qIdCEzcs=";
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
    # libgdata
    lua5_4
    liboauth
    sqlite
    gnome-online-accounts
    totem-pl-parser
    libarchive
    libdmapsharing
    libsoup_3
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
    platforms = platforms.unix;
  };
}
