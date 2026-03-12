{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  scdoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wl-restart";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Ferdi265";
    repo = "wl-restart";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wLaZBqw/Yx0Oc7s3ffAmx3zakjhEBHM09uJcfsVHbnQ=";
  };

  cmakeFlags = [ (lib.cmakeBool "INSTALL_DOCUMENTATION" true) ];

  nativeBuildInputs = [
    scdoc
    cmake
  ];

  meta = {
    description = "Simple tool that restarts your compositor when it crashes";
    homepage = "https://github.com/Ferdi265/wl-restart";
    changelog = "https://github.com/Ferdi265/wl-restart/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "wl-restart";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.linux;
  };
})
