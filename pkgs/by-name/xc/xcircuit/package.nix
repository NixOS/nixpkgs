{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  automake,
  pkg-config,
  cairo,
  ghostscript,
  ngspice,
  tcl,
  tk,
  libxt,
  libxpm,
  libx11,
  libsm,
  libice,
  zlib,
}:

stdenv.mkDerivation {
  version = "3.10.37";
  pname = "xcircuit";

  src = fetchFromGitHub {
    owner = "RTimothyEdwards";
    repo = "XCircuit";
    rev = "0056213308c92bec909e8469a0fa1515b72fc3d2";
    sha256 = "sha256-LXU5VEkLF1aKYz9ynI1qQjJUwt/zKFMPYj153OgJOOI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    automake
    pkg-config
  ];
  hardeningDisable = [ "format" ];

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tk=${tk}/lib"
    "--with-ngspice=${lib.getBin ngspice}/bin/ngspice"
  ];

  patches = [
    # fix compilation with GCC 14
    ./declare-missing-prototype.patch
  ];

  buildInputs = [
    cairo
    ghostscript
    libsm
    libxt
    libice
    libx11
    libxpm
    tcl
    tk
    zlib
  ];

  meta = {
    description = "Generic drawing program tailored to circuit diagrams";
    mainProgram = "xcircuit";
    homepage = "http://opencircuitdesign.com/xcircuit";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      john-shaffer
      spacefrogg
      thoughtpolice
    ];
  };
}
