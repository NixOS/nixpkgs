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

  sourceRoot = "${finalAttrs.src.name}/wox.ui.flutter/wox";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes.extended_text_field = "sha256-GOvaWGklfmJKRWYbVTvpZfKj9QMxxlaqrJkfDKR2T0o=";
  gitHashes.windows_gpu_recovery = "sha256-+LQV2wgbQ0ADM2KeRfgbvCHPODBBsq5XrPulXl6GWG8=";

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
