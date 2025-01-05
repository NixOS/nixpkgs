{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "u3-tool";
  version = "1.0";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    # original sourceforge mirror does not provide direct access to tag 1.0
    owner = "marcusrugger";
    repo = "u3-tool";
    rev = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-c3cfWUUT5lwy8OedAtwvhuNEa5hgfwrKGJPY/zAlALw=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  meta = {
    description = "Tool for controlling the special features of a 'U3 smart drive' USB Flash disk";
    homepage = "https://sourceforge.net/projects/u3-tool/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ makefu ];
    mainProgram = "u3-tool";
  };
})
