{
  lib,
  buildPythonPackage,
  stdenv,
  anki,
  hatchling,
  pyprojectVersionPatchHook,
  swift,
}:

buildPythonPackage (finalAttrs: {
  pname = "anki-mac-helper";
  version = "0.1.1";
  inherit (anki) src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/qt/mac";

  build-system = [ hatchling ];
  nativeBuildInputs = [
    # Rewrite upstream version to match main Anki version
    pyprojectVersionPatchHook
    swift
  ];

  # This is intended to emulate github:ankitects/anki/qt/mac/helper_build.py,
  # but targets the platform directly instead of universal binary + lipo.
  preBuild = ''
    swiftc \
      -target ${stdenv.hostPlatform.swift.triple} \
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
