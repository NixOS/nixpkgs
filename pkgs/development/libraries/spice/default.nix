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

let
  # This file was mistakenly not included with the 0.15.0 release tarball.
  # Should be fixed with the next release.
  # https://gitlab.freedesktop.org/spice/spice/-/issues/56
  doxygen_sh = fetchurl {
    url = "https://gitlab.freedesktop.org/spice/spice/-/raw/v0.15.0/doxygen.sh";
    sha256 = "0g4bx91qclihp1jfhdhyj7wp4hf4289794xxbw32kk58lnd7bzkg";
  };
in

stdenv.mkDerivation rec {
  pname = "spice";
  version = "0.15.0";

  src = fetchurl {
    url = "https://www.spice-space.org/download/releases/spice-server/${pname}-${version}.tar.bz2";
    sha256 = "1xd0xffw0g5vvwbq4ksmm3jjfq45f9dw20xpmi82g1fj9f7wy85k";
  };

  patches = [
    ./remove-rt-on-darwin.patch
  ];
  postPatch = ''
    install ${doxygen_sh} doxygen.sh
    patchShebangs build-aux

    # https://gitlab.freedesktop.org/spice/spice-common/-/issues/5
    substituteInPlace subprojects/spice-common/meson.build \
      --replace \
      "cmd = run_command(python, '-m', module)" \
      "cmd = run_command(python, '-c', 'import @0@'.format(module))"
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
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
  ] ++ lib.optionals stdenv.isDarwin [
    gdk-pixbuf
  ];

  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  mesonFlags = [
    "-Dgstreamer=1.0"
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

    maintainers = with maintainers; [ bluescreen303 atemu ];
    platforms = with platforms; linux ++ darwin;
  };
}
