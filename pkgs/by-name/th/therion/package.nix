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
  wxwidgets_3_2,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "therion";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "therion";
    repo = "therion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TiyoNYk+wWXyNytQwr5EfRSWzNc42LX3qjMV9M+dsx0=";
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
    wxwidgets_3_2
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
    changelog = "https://github.com/therion/therion/blob/${finalAttrs.src.rev}/CHANGES";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ matthewcroughan ];
  };
})
