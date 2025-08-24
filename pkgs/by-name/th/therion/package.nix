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
  catch2,
}:

stdenv.mkDerivation rec {
  pname = "therion";
  version = "6.3.4";

  src = fetchFromGitHub {
    owner = "therion";
    repo = "therion";
    tag = "v${version}";
    hash = "sha256-kus5MoiUrLadpzq0wPB+J85F0RVva7NAYM6E6HX4eJ8=";
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
    catch2
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

  meta = {
    description = "Cave surveying software";
    homepage = "https://therion.speleo.sk/";
    changelog = "https://github.com/therion/therion/blob/${src.rev}/CHANGES";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ matthewcroughan ];
  };
}
