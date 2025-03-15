{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  SDL2,
  SDL2_image,
  rtaudio,
  rtmidi,
  glew,
  alsa-lib,
  angelscript,
  cmake,
  pkg-config,
  zenity,
}:
let
  # package depends on SDL2main static library
  SDL2' = SDL2.override {
    withStatic = true;
  };
in
stdenv.mkDerivation rec {
  pname = "theforceengine";
  version = "1.15.000";

  src = fetchFromGitHub {
    owner = "luciusDXL";
    repo = "TheForceEngine";
    rev = "v${version}";
    hash = "sha256-pcPR2KCGbyL1JABF30yJrlcLPGU2h0//Ghf7e7zYO0s=";
  };

  patches = [
    # https://github.com/luciusDXL/TheForceEngine/pull/493 -- fixes finding data files outside program directory
    (fetchpatch {
      url = "https://github.com/luciusDXL/TheForceEngine/commit/476a5277666bfdffb33ed10bdd1177bfe8ec3a70.diff";
      hash = "sha256-ZcfKIXQMcWMmnM4xfQRd/Ozl09vkQr3jUxZ5e4Mw5CU=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2'
    SDL2_image
    rtaudio
    rtmidi
    glew
    alsa-lib
    angelscript
  ];

  hardeningDisable = [ "format" ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_EDITOR" true)
    (lib.cmakeBool "ENABLE_FORCE_SCRIPT" true)
  ];

  prePatch = ''
    # use nix store path instead of hardcoded /usr/share for support data
    substituteInPlace TheForceEngine/TFE_FileSystem/paths-posix.cpp \
      --replace-fail "/usr/share" "$out/share"

    # use zenity from nix store
    substituteInPlace TheForceEngine/TFE_Ui/portable-file-dialogs.h \
      --replace-fail "check_program(\"zenity\")" "check_program(\"${lib.getExe zenity}\")" \
      --replace-fail "flags(flag::has_zenity) ? \"zenity\"" "flags(flag::has_zenity) ? \"${lib.getExe zenity}\""
  '';

  meta = with lib; {
    description = "Modern \"Jedi Engine\" replacement supporting Dark Forces, mods, and in the future, Outlaws";
    mainProgram = "theforceengine";
    homepage = "https://theforceengine.github.io";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ devusb ];
    platforms = [ "x86_64-linux" ];
  };
}
