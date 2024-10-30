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
, gdk-pixbuf
}:

stdenv.mkDerivation rec {
  pname = "spice";
  version = "0.15.2";

  src = fetchurl {
    url = "https://www.spice-space.org/download/releases/spice-server/${pname}-${version}.tar.bz2";
    sha256 = "sha256-bZ62EX8DkXRxxLwQAEq+z/SKefuF64WhxF8CM3cBW4E=";
  };

  patches = [
    ./remove-rt-on-darwin.patch
  ];

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
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    gdk-pixbuf
  ];

  env.NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  mesonFlags = [
    "-Dgstreamer=1.0"
  ];

  postPatch = ''
    patchShebangs build-aux

    # Forgotten in 0.15.2 tarball
    sed -i /meson.add_dist_script/d meson.build
  '';

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

    maintainers = with maintainers; [ bluescreen303 atemu ];
    platforms = with platforms; linux ++ darwin;
  };
}
