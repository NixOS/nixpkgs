{ stdenv, fetchurl, substituteAll, intltool, itstool, libxslt
, meson, ninja, pkgconfig, vala, wrapGAppsHook, bzip2, dbus, evolution-data-server
, exempi, flac, giflib, glib, gnome3, gst_all_1, icu, json-glib, libcue, libexif
, libgrss, libgsf, libiptcdata, libjpeg, libpng, libseccomp, libsoup, libtiff, libuuid
, libvorbis, libxml2, poppler, taglib, upower }:

let
  pname = "tracker-miners";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "2.1.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "107638773mihxdi194wf3saacqrr4cp9xn3qjfmx60bwq5451ma0";
  };

  nativeBuildInputs = [
    intltool
    itstool
    libxslt
    meson
    ninja
    pkgconfig
    vala
    wrapGAppsHook
  ];

  # TODO: add libenca, libosinfo
  buildInputs = [
    bzip2
    dbus
    evolution-data-server
    exempi
    flac
    giflib
    glib
    gnome3.gexiv2
    gnome3.totem-pl-parser
    gnome3.tracker
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    icu
    json-glib
    libcue
    libexif
    libgrss
    libgsf
    libiptcdata
    libjpeg
    libpng
    libseccomp
    libsoup
    libtiff
    libuuid
    libvorbis
    libxml2
    poppler
    taglib
    upower
  ];

  mesonFlags = [
    # TODO: tests do not like our sandbox
    "-Dfunctional_tests=false"
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit (gnome3) tracker;
    })
    # https://bugzilla.gnome.org/show_bug.cgi?id=795576
    (fetchurl {
      url = https://bugzilla.gnome.org/attachment.cgi?id=371427;
      sha256 = "187flswvzymjfxwfrrhizb1cvs780zm39aa3i2vwa5fbllr7kcpf";
    })
  ];

  # Symlinks require absolute path and we still cannot use placeholders
  # https://github.com/NixOS/nixpkgs/pull/39534#discussion_r184339131
  # https://github.com/NixOS/nixpkgs/pull/37693
  preConfigure = ''
    mesonFlagsArray+=("-Ddbus_services=$out/share/dbus-1/services")
  '';

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Tracker;
    description = "Desktop-neutral user information store, search tool and indexer";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
