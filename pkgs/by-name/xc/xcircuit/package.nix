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
  version = "3.10.42";
  pname = "xcircuit";

  src = fetchFromGitHub {
    owner = "RTimothyEdwards";
    repo = "XCircuit";
    rev = "8a0429250abbd2b70c4d3fbfe2e2c20b4c43be81";
    sha256 = "sha256-ijJYppWuEYcb2RLVsvGHu+7YRp027MNDDcqxSKLHORU=";
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
