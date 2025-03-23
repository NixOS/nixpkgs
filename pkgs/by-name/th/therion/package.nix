{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  perl,
  tcl,
  tclPackages,
  tk,
  expat,
  python3,
  texliveTeTeX,
  survex,
  makeWrapper,
  fmt,
  proj,
  wxGTK32,
  vtk,
  freetype,
  libjpeg,
  gettext,
  libGL,
  libGLU,
  sqlite,
  libtiff,
  curl,
}:

stdenv.mkDerivation rec {
  pname = "therion";
  version = "6.1.8";

  src = fetchFromGitHub {
    owner = "therion";
    repo = "therion";
    rev = "v${version}";
    hash = "sha256-bmp0IZ4uAqDpe2e8UeIDUdFaaocx4OBIYuhnaHirqGc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    perl
    python3
    texliveTeTeX
    makeWrapper
    tcl.tclPackageHook
  ];

  preConfigure = ''
    export OUTDIR=$out
  '';

  cmakeFlags = [
    "-DBUILD_THBOOK=OFF"
  ];

  buildInputs = [
    expat
    tclPackages.tkimg
    proj
    wxGTK32
    vtk
    tk
    freetype
    libjpeg
    gettext
    libGL
    libGLU
    sqlite
    libtiff
    curl
    fmt
    tcl
    tclPackages.tcllib
    tclPackages.bwidget
  ];

  fixupPhase = ''
    runHook preFixup
    wrapProgram $out/bin/therion \
      --prefix PATH : ${
        lib.makeBinPath [
          survex
          texliveTeTeX
        ]
      }
    wrapProgram $out/bin/xtherion \
      --prefix PATH : ${lib.makeBinPath [ tk ]}
    runHook postFixup
  '';

  meta = with lib; {
    description = "Therion – cave surveying software";
    homepage = "https://therion.speleo.sk/";
    changelog = "https://github.com/therion/therion/blob/${src.rev}/CHANGES";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
