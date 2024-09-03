{ lib
, stdenv
, fetchFromGitHub
, SDL2
, SDL2_image
, rtaudio
, rtmidi
, glew
, alsa-lib
, cmake
, pkg-config
, zenity
}:
let
  # package depends on SDL2main static library
  SDL2' = SDL2.override {
    withStatic = true;
  };
in
stdenv.mkDerivation rec {
  pname = "theforceengine";
  version = "1.10.000";

  src = fetchFromGitHub {
    owner = "luciusDXL";
    repo = "TheForceEngine";
    rev = "v${version}";
    hash = "sha256-oEcjHb6HY5qxKuPoNBuobPbdi39hUUWtKSb7FbAfEpc=";
  };

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
