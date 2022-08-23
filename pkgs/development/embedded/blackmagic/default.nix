{ stdenv, lib
, fetchFromGitHub
, gcc-arm-embedded
, pkg-config
, python3
, hidapi
, libftdi1
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "blackmagic";
  version = "unstable-2022-04-16";
  # `git describe --always`
  firmwareVersion = "v1.7.1-415-gc4869a5";

  src = fetchFromGitHub {
    owner = "blacksphere";
    repo = "blackmagic";
    rev = "c4869a54733ae92099a7316954e34d1ab7b6097c";
    hash = "sha256-0MC1v/5u/txSshxkOI5TErMRRrYCcHly3qbVTAk9Vc0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gcc-arm-embedded
    pkg-config
    python3
  ];

  buildInputs = [
    hidapi
    libftdi1
    libusb1
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

  buildPhase = ''
    runHook preBuild
    ${stdenv.shell} ${./helper.sh}
    runHook postBuild
  '';

  dontInstall = true;

  enableParallelBuilding = true;

  meta = with lib; {
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
