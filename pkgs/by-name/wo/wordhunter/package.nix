{
  appimageTools,
  fetchurl,
  lib,
}:

let
  pname = "wordhunter";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/Ironship/WordHunter/releases/download/WordHunter${version}/WordHunter-${version}-x86_64.AppImage";
    hash = "sha256-e+dduzoxYahFHKitLcEWGSHA7XkagQj0iGl4HuLKMCI=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
(appimageTools.wrapAppImage {
  inherit pname version;

  src = appimageContents;

  extraInstallCommands = ''
    install -m 444 -D \
      "${appimageContents}/usr/share/applications/Word Hunter.desktop" \
      "$out/share/applications/com.wordhunter.app.desktop"
    substituteInPlace "$out/share/applications/com.wordhunter.app.desktop" \
      --replace-fail 'Exec=word-hunter-rustified' 'Exec=wordhunter'

    cp -r "${appimageContents}/usr/share/icons" "$out/share/"

    install -m 444 -D \
      "${appimageContents}/usr/share/metainfo/com.wordhunter.app.metainfo.xml" \
      "$out/share/metainfo/com.wordhunter.app.metainfo.xml"
    substituteInPlace "$out/share/metainfo/com.wordhunter.app.metainfo.xml" \
      --replace-fail \
        '<binary>word-hunter-rustified</binary>' \
        '<binary>wordhunter</binary>'
  '';

  passthru = {
    inherit appimageContents src;
  };

  meta = {
    description = "Local-first reader and vocabulary trainer";
    homepage = "https://ironship.github.io/WordHunter-site/";
    downloadPage = "https://github.com/Ironship/WordHunter/releases";
    changelog = "https://github.com/Ironship/WordHunter/releases/tag/WordHunter${version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ ironship ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "wordhunter";
    platforms = [ "x86_64-linux" ];
  };
}).overrideAttrs
  (_: {
    strictDeps = true;
  })
