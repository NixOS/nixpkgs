{ stdenv, fetchurl, substituteAll, intltool, itstool, libxslt, makeWrapper
, meson, ninja, pkgconfig, vala, wrapGAppsHook, bzip2, dbus, evolution-data-server
, exempi, flac, giflib, glib, gnome3, gst_all_1, icu, json-glib, libcue, libexif
, libgsf, libiptcdata, libjpeg, libpng, libseccomp, libsoup, libtiff, libuuid
, libvorbis, libxml2, poppler, taglib, upower }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "tracker-miners";
  version = "2.0.4";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0mp9m2waii583sjgr61m1ni6py6dry11r0rzidgvw1g4cxhn89j6";
  };

  # https://github.com/NixOS/nixpkgs/issues/39547
  LIBRARY_PATH = stdenv.lib.makeLibraryPath [ giflib ];

  nativeBuildInputs = [
    intltool
    itstool
    libxslt
    makeWrapper
    meson
    ninja
    pkgconfig
    vala
    wrapGAppsHook
  ];

  # TODO: add libgrss, libenca, libosinfo
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
    "-Dminer_rss=false" # needs libgrss
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit (gnome3) tracker;
    })
    # https://bugzilla.gnome.org/show_bug.cgi?id=795573
    (fetchurl {
      url = https://bugzilla.gnome.org/attachment.cgi?id=371422;
      sha256 = "1rzwzrc7q73k42s1j1iw52chy10w6y3xksfrzg2l42nn9wk7n281";
    })
    # https://bugzilla.gnome.org/show_bug.cgi?id=795574
    (fetchurl {
      url = https://bugzilla.gnome.org/attachment.cgi?id=371423;
      sha256 = "0b2ck8z4b2yrgwg4v9jsac5n8h3a91qkp90vv17wxcvr4v50fg48";
    })
    # https://bugzilla.gnome.org/show_bug.cgi?id=795575
    (fetchurl {
      url = https://bugzilla.gnome.org/attachment.cgi?id=371424;
      sha256 = "03i29fabxrpraydh7712vdrc571qmiq0l4axj24gbi6h77xn7mxc";
    })
    # https://bugzilla.gnome.org/show_bug.cgi?id=795576
    (fetchurl {
      url = https://bugzilla.gnome.org/attachment.cgi?id=371427;
      sha256 = "187flswvzymjfxwfrrhizb1cvs780zm39aa3i2vwa5fbllr7kcpf";
    })
    # https://bugzilla.gnome.org/show_bug.cgi?id=795577
    (fetchurl {
      url = https://bugzilla.gnome.org/attachment.cgi?id=371425;
      sha256 = "05m629469jr2lm2cjs54n7xwyim2d5rwwvdjxzcwh5qpfjds5phm";
    })
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  # https://github.com/NixOS/nixpkgs/pull/39534#discussion_r184339131
  # https://github.com/NixOS/nixpkgs/pull/37693
  preConfigure = ''
    mesonFlagsArray+=("-Ddbus_services=$out/share/dbus-1/services")
  '';

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';
  
  # https://bugzilla.gnome.org/show_bug.cgi?id=796145
  postFixup = ''
    rm $out/share/tracker/miners/org.freedesktop.Tracker1.Miner.RSS.service
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Tracker;
    description = "Desktop-neutral user information store, search tool and indexer";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
