{
  lib,
  flutter341,
  wox,
  autoPatchelfHook,
  keybinder3,
  xorgproto,
  libx11,
  libxtst,
}:
flutter341.buildFlutterApplication (finalAttrs: {
  pname = "wox-ui-flutter";
  inherit (wox)
    version
    src
    ;

  postPatch = ''
    substituteInPlace linux/runner/my_application.cc \
      --replace-fail "X11/Xkeysym.h" "X11/keysym.h"
  '';

  sourceRoot = "${finalAttrs.src.name}/wox.ui.flutter/wox";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    keybinder3
    xorgproto
    libx11
    libxtst
  ];

  meta = {
    inherit (wox.meta)
      description
      homepage
      mainProgram
      platforms
      license
      maintainers
      ;
  };
})
