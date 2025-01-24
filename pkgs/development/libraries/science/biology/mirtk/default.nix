{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  boost186,
  eigen,
  libGLU,
  fltk,
  vtk,
  zlib,
  tbb,
}:

stdenv.mkDerivation {
  pname = "mirtk";
  version = "unstable-2022-07-22";

  src = fetchFromGitHub {
    owner = "BioMedIA";
    repo = "MIRTK";
    rev = "973ce2fe3f9508dec68892dbf97cca39067aa3d6";
    hash = "sha256-vKgkDrbyGOcbaYlxys1duC8ZNG0Y2nqh3TtSQ06Ox0Q=";
    fetchSubmodules = true;
  };

  cmakeFlags = [
    "-DWITH_VTK=ON"
    "-DMODULE_Deformable=ON"
    "-DMODULE_Mapping=ON"
    "-DMODULE_Scripting=ON"
    "-DMODULE_Viewer=ON"
    "-DMODULE_DrawEM=OFF"
    "-DWITH_TBB=ON"
    "-DWITH_GIFTICLIB=ON"
    "-DWITH_NIFTILIB=ON"
  ];

  # tests don't seem to be maintained and gtest fails to link with BUILD_TESTING=ON;
  # unclear if specific to Nixpkgs
  doCheck = false;

  postInstall = ''
    install -Dm644 -t "$out/share/bash-completion/completions/mirtk" share/completion/bash/mirtk
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-changes-meaning";

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost186
    eigen
    fltk
    libGLU
    python3
    tbb
    vtk
    zlib
  ];

  meta = {
    homepage = "https://github.com/BioMedIA/MIRTK";
    description = "Medical image registration library and tools";
    mainProgram = "mirtk";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
  };
}
