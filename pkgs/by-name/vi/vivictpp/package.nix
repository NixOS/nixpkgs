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
  version = "1.3.1";
  withSubprojects = stdenv.mkDerivation {
    pname = "sources-with-subprojects";
    inherit version;

    src = fetchFromGitHub {
      owner = "vivictorg";
      repo = "vivictpp";
      tag = "v${version}";
      fetchSubmodules = true;
      hash = "sha256-g/M3blW48uwL6v60IU4sRObYvR7Gjjn/X0lYSS86x+0=";
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
    outputHash = "sha256-UbULDurC6qbcjP+fZJgd0nSVsimAyw3sYC08xeXcI14=";
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
