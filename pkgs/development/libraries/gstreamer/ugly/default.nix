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
}:

stdenv.mkDerivation rec {
  pname = "gst-plugins-ugly";
  version = "1.19.3";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1s86girzks0z6j06w4008gg5a3scj8pmsyjj60k4ymbwx2li16nl";
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
    a52dec
    libcdio
    libdvdread
    libmad
    libmpeg2
    x264
    libintl
    opencore-amr
  ] ++ lib.optionals stdenv.isDarwin [
    IOKit
    CoreFoundation
    DiskArbitration
  ];

  mesonFlags = [
    "-Ddoc=disabled" # `hotdoc` not packaged in nixpkgs as of writing
    "-Dsidplay=disabled" # sidplay / sidplay/player.h isn't packaged in nixpkgs as of writing
    "-Dgpl=enabled"
  ];

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
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
