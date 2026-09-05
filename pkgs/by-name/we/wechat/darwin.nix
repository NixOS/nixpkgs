{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,

  passthru,
  pname,
  meta,
  ...
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname;

  inherit (finalAttrs.passthru.source) version;
  src = fetchurl finalAttrs.passthru.source.src;

  strictDeps = true;
  __structuredAttrs = true;

  # dmg is APFS formatted
  nativeBuildInputs = [ _7zz ];
  # ERROR: Dangerous link path was ignored : WeChat.app/Contents/MacOS/WeChatAppEx.app/Contents/Frameworks/WeChatAppEx Framework.framework/Versions/C/Libraries/xfile/libxfile_skia.dylib : ../xeditor/libxeditor_app.dylib
  unpackCmd = ''
    7zz x -snld "$curSrc"
  '';

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -a WeChat.app $out/Applications

    runHook postInstall
  '';

  passthru = passthru // {
    source =
      finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system}
        or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
  };

  meta = meta // {
    platforms = lib.attrNames finalAttrs.passthru.sources;
  };
})
