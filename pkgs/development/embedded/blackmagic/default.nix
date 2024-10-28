{
  stdenv,
  lib,
  fetchFromGitHub,
  gnumake,
  pkg-config,
  python3,
  hidapi,
  libftdi1,
  libusb1,
  gcc-arm-embedded-12-2-rel1,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "blackmagic";
  version = "1.10.2";
  # `git describe --always`
  firmwareVersion = "v${version}";

  src = fetchFromGitHub {
    owner = "blackmagic-debug";
    repo = "blackmagic";
    rev = "refs/tags/${firmwareVersion}";
    hash = "sha256-ZhcVGSES+RPSjS7Pdk1EGWF8MfIW19HmHbvYtzMECME=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gnumake
    pkg-config
    python3
    # only this or previous versions of gcc-arm-embedded builds 1.10.2 in a way that fits into rom for the native platform
    # https://github.com/blackmagic-debug/blackmagic/issues/1978
    gcc-arm-embedded-12-2-rel1
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
      --replace-fail '$(shell if [ -e "../.git" ]; then git describe --always --dirty --tags; fi)' '${firmwareVersion}'

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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "In-application debugger for ARM Cortex microcontrollers";
    mainProgram = "blackmagic";
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
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      pjones
      sorki
      carlossless
    ];
    platforms = lib.platforms.unix;
  };
}
