{
  pname,
  version,
  src,
  meta,
  stdenvNoCC,
  _7zz,
}:

stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    src
    meta
    ;

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
}
