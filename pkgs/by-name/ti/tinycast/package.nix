{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:

let
  sources = lib.importJSON ./sources.json;
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tinycast";
  inherit (sources) version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/abue-ammar/tinycast/releases/download/${sources.tag}/Tinycast-Universal-${sources.version}.dmg";
    inherit (sources) hash;
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  # Tinycast.dmg is APFS formatted, which is unsupported by undmg.
  nativeBuildInputs = [ _7zz ];

  sourceRoot = "Tinycast.app";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Tinycast.app"
    cp -R . "$out/Applications/Tinycast.app"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Native macOS launcher with hotkeys and clipboard history";
    homepage = "https://github.com/abue-ammar/tinycast";
    changelog = "https://github.com/abue-ammar/tinycast/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ pwnwriter ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
