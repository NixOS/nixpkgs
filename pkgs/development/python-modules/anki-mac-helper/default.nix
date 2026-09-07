{
  lib,
  buildPythonPackage,
  stdenv,
  anki,
  hatchling,
  swift,
}:

buildPythonPackage (finalAttrs: {
  pname = "anki-mac-helper";
  inherit (anki) version src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/qt/mac";

  build-system = [ hatchling ];
  nativeBuildInputs = [ swift ];

  # This is intended to emulate github:ankitects/anki/qt/mac/helper_build.py,
  # but targets the platform directly instead of universal binary + lipo.
  preBuild = ''
    swiftc \
      -target ${stdenv.hostPlatform.darwinArch}-apple-macos11 \
      -emit-library \
      -module-name ankihelper \
      -O \
      *.swift \
      -o anki_mac_helper/libankihelper.dylib
  '';

  pythonImportsCheck = [ "anki_mac_helper" ];

  meta = {
    description = "Small support library for Anki on Macs";
    homepage = "https://github.com/ankitects/anki";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = lib.platforms.darwin;
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      euank
      junestepp
      oxij
    ];
  };
})
