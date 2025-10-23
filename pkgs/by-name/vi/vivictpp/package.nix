{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  cmake,
  ninja,
  pkg-config,
  python3,
  git,
  SDL2,
  SDL2_ttf,
  libX11,
  freetype,
  harfbuzz,
  ffmpeg,
  cacert,
  zlib,
  writeShellScript,
  nix-update,
}:

let
  version = "1.3.0";
  withSubprojects = stdenv.mkDerivation {
    pname = "sources-with-subprojects";
    inherit version;

    src = fetchFromGitHub {
      owner = "vivictorg";
      repo = "vivictpp";
      tag = "v${version}";
      fetchSubmodules = true;
      hash = "sha256-yzUgLZbqEzyJINWQUTC/j33XbjSXP1vpDlgiKv6Jx9Q=";
    };

    nativeBuildInputs = [
      meson
      cacert
      git
    ];

    buildCommand = ''
      cp -r --no-preserve=mode $src $out
      cd $out

      meson subprojects download
      find subprojects -type d -name .git -prune -execdir rm -r {} +
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-PtOb47QOffGje1U8Tle9AQon7ZCgMp/lITPAfM9/wr4=";
  };
in
stdenv.mkDerivation {
  pname = "vivictpp";
  inherit version;

  src = withSubprojects;

  nativeBuildInputs = [
    meson
    cmake
    ninja
    pkg-config

    python3
    git
  ];

  buildInputs = [
    SDL2
    libX11
    SDL2_ttf
    freetype
    harfbuzz
    ffmpeg
    zlib
  ];

  preConfigure = ''
    patchShebangs .
  '';

  passthru.updateScript = writeShellScript "update-vivictpp" ''
    ${lib.getExe nix-update} vivictpp.src
    ${lib.getExe nix-update} vivictpp --version skip
  '';

  meta = {
    description = "Easy to use tool for subjective comparison of the visual quality of different encodings of the same video source";
    homepage = "https://github.com/vivictorg/vivictpp";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ tilpner ];
    mainProgram = "vivictpp";
  };
}
