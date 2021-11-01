{ lib, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, pixman
, alsa-lib
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
  version = "0.15.0";

  src = fetchurl {
    url = "https://www.spice-space.org/download/releases/spice-server/${pname}-${version}.tar.bz2";
    sha256 = "1xd0xffw0g5vvwbq4ksmm3jjfq45f9dw20xpmi82g1fj9f7wy85k";
  };

  postPatch = ''
    patchShebangs build-aux
  '';


  nativeBuildInputs = [
    glib
    meson
    ninja
    pkg-config
    python3
    python3.pkgs.six
    python3.pkgs.pyparsing
  ];

  buildInputs = [
    alsa-lib
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
    spice-protocol
    zlib
  ];

  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  mesonFlags = [
    "-Dgstreamer=1.0"
    "-Dcelt051=disabled"
  ];

  postInstall = ''
    ln -s spice-server $out/include/spice
  '';

  meta = with lib; {
    description = "Complete open source solution for interaction with virtualized desktop devices";
    longDescription = ''
      The Spice project aims to provide a complete open source solution for interaction
      with virtualized desktop devices.The Spice project deals with both the virtualized
      devices and the front-end. Interaction between front-end and back-end is done using
      VD-Interfaces. The VD-Interfaces (VDI) enable both ends of the solution to be easily
      utilized by a third-party component.
    '';
    homepage = "https://www.spice-space.org/";
    license = licenses.lgpl21;

    maintainers = [ maintainers.bluescreen303 ];
    platforms = platforms.linux;
  };
}
