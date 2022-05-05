{ stdenv
, fetchurl
, meson
, ninja
, pkg-config
, python3
, gst-plugins-base
, orc
, gettext
, a52dec
, libcdio
, libdvdread
, libmad
, libmpeg2
, x264
, libintl
, lib
, opencore-amr
, IOKit
, CoreFoundation
, DiskArbitration
, enableGplPlugins ? true
}:

stdenv.mkDerivation rec {
  pname = "gst-plugins-ugly";
  version = "1.20.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "06fvgyjwcf4paqxgp1xmgd0d0glkxys7n818526k10wrw92m20s2";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    python3
  ];

  buildInputs = [
    gst-plugins-base
    orc
    libintl
    opencore-amr
  ] ++ lib.optionals enableGplPlugins [
    a52dec
    libcdio
    libdvdread
    libmad
    libmpeg2
    x264
  ] ++ lib.optionals stdenv.isDarwin [
    IOKit
    CoreFoundation
    DiskArbitration
  ];

  mesonFlags = [
    "-Ddoc=disabled" # `hotdoc` not packaged in nixpkgs as of writing
    "-Dsidplay=disabled" # sidplay / sidplay/player.h isn't packaged in nixpkgs as of writing
  ] ++ (if enableGplPlugins then [
    "-Dgpl=enabled"
  ] else [
    "-Da52dec=disabled"
    "-Dcdio=disabled"
    "-Ddvdread=disabled"
    "-Dmpeg2dec=disabled"
    "-Dsidplay=disabled"
    "-Dx264=disabled"
  ]);

  postPatch = ''
    patchShebangs \
      scripts/extract-release-date-from-doap-file.py
  '';

  meta = with lib; {
    description = "Gstreamer Ugly Plugins";
    homepage = "https://gstreamer.freedesktop.org";
    longDescription = ''
      a set of plug-ins that have good quality and correct functionality,
      but distributing them might pose problems.  The license on either
      the plug-ins or the supporting libraries might not be how we'd
      like. The code might be widely known to present patent problems.
    '';
    license = if enableGplPlugins then licenses.gpl2Plus else licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
