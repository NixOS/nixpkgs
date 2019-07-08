{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, pixman
, alsaLib
, openssl
, libXrandr
, libXfixes
, libXext
, libXrender
, libXinerama
, libjpeg
, zlib
, spice-protocol
, python3
, glib
, cyrus_sasl
, libcacard
, lz4
, libopus
, gst_all_1
, orc
}:

stdenv.mkDerivation rec {
  pname = "spice";
  version = "0.14.2";

  src = fetchurl {
    url = "https://www.spice-space.org/download/releases/${pname}-${version}.tar.bz2";
    sha256 = "19r999py9v9c7md2bb8ysj809ag1hh6djl1ik8jcgx065s4b60xj";
  };

  patches = [
    # submitted https://gitlab.freedesktop.org/spice/spice/merge_requests/4
    ./correct-meson.patch
  ];

  postPatch = ''
    patchShebangs build-aux
  '';


  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    spice-protocol
    python3
    python3.pkgs.six
    python3.pkgs.pyparsing
  ];

  buildInputs = [
    alsaLib
    cyrus_sasl
    glib
    gst_all_1.gst-plugins-base
    libXext
    libXfixes
    libXinerama
    libXrandr
    libXrender
    libcacard
    libjpeg
    libopus
    lz4
    openssl
    orc
    pixman
    python3.pkgs.pyparsing
    zlib
  ];

  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  mesonFlags = [
    "-Dauto_features=enabled"
    "-Dgstreamer=1.0"
    "-Dcelt051=disabled"
  ];

  postInstall = ''
    ln -s spice-server $out/include/spice
  '';

  meta = with stdenv.lib; {
    description = "Complete open source solution for interaction with virtualized desktop devices";
    longDescription = ''
      The Spice project aims to provide a complete open source solution for interaction
      with virtualized desktop devices.The Spice project deals with both the virtualized
      devices and the front-end. Interaction between front-end and back-end is done using
      VD-Interfaces. The VD-Interfaces (VDI) enable both ends of the solution to be easily
      utilized by a third-party component.
    '';
    homepage = https://www.spice-space.org/;
    license = licenses.lgpl21;

    maintainers = [ maintainers.bluescreen303 ];
    platforms = platforms.linux;
  };
}
