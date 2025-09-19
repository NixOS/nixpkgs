{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_image,
  libX11,
  rtaudio,
  rtmidi,
  glew,
  alsa-lib,
  angelscript,
  cmake,
  pkg-config,
  zenity,
  withEditor ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "theforceengine";
  version = "1.22.410";

  src = fetchFromGitHub {
    owner = "luciusDXL";
    repo = "TheForceEngine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ydZ/S6u3UQNeVRTfzjshlNzLRc1y3FXsTY2NXbUoJBA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_image
    libX11
    rtaudio
    rtmidi
    glew
    alsa-lib
    angelscript
    zenity
  ];

  hardeningDisable = [ "format" ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_EDITOR" withEditor)
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

  meta = {
    description = "Modern \"Jedi Engine\" replacement supporting Dark Forces, mods, and in the future, Outlaws";
    mainProgram = "theforceengine";
    homepage = "https://theforceengine.github.io";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ devusb ];
    platforms = lib.platforms.linux;
  };
})
