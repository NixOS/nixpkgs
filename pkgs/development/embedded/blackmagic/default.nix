{ stdenv, lib, fetchFromGitHub, fetchpatch
, gcc-arm-embedded, libftdi1, libusb-compat-0_1, pkg-config
, python3
}:

with lib;

stdenv.mkDerivation rec {
  pname = "blackmagic";
  version = "unstable-2020-08-05";
  # `git describe --always`
  firmwareVersion = "v1.6.1-539-gdd74ec8";

  src = fetchFromGitHub {
    owner = "blacksphere";
    repo = "blackmagic";
    rev = "dd74ec8e6f734302daa1ee361af88dfb5043f166";
    sha256 = "18w8y64fs7wfdypa4vm3migk5w095z8nbd8qp795f322mf2bz281";
    fetchSubmodules = true;
  };

  patches = [
    # Fix deprecation warning with libftdi 1.5
    (fetchpatch {
      url = "https://github.com/blacksphere/blackmagic/commit/dea4be2539c5ea63836ec78dca08b52fa8b26ab5.patch";
      sha256 = "0f81simij1wdhifsxaavalc6yxzagfbgwry969dbjmxqzvrsrds5";
    })
  ];

  nativeBuildInputs = [
    gcc-arm-embedded pkg-config
    python3
  ];

  buildInputs = [
    libftdi1
    libusb-compat-0_1
  ];

  strictDeps = true;

  postPatch = ''
    # Prevent calling out to `git' to generate a version number:
    substituteInPlace src/Makefile \
      --replace '$(shell git describe --always --dirty)' '${firmwareVersion}'

    # Fix scripts that generate headers:
    for f in $(find scripts libopencm3/scripts -type f); do
      patchShebangs "$f"
    done
  '';

  buildPhase = "${stdenv.shell} ${./helper.sh}";
  dontInstall = true;

  enableParallelBuilding = true;

  meta = {
    description = "In-application debugger for ARM Cortex microcontrollers";
    longDescription = ''
      The Black Magic Probe is a modern, in-application debugging tool
      for embedded microprocessors. It allows you to see what is going
      on "inside" an application running on an embedded microprocessor
      while it executes.

      This package builds the firmware for all supported platforms,
      placing them in separate directories under the firmware
      directory.  It also places the FTDI version of the blackmagic
      executable in the bin directory.
    '';
    homepage = "https://github.com/blacksphere/blackmagic";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pjones emily sorki ];
    # fails on darwin with
    # arm-none-eabi-gcc: error: unrecognized command line option '-iframework'
    platforms = platforms.linux;
  };
}
