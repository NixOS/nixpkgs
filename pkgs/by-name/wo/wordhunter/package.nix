{
  appimageTools,
  fetchurl,
  lib,
  syncthing,
}:

let
  pname = "wordhunter";
  version = "1.0.6";

  src = fetchurl {
    url = "https://github.com/Ironship/WordHunter/releases/download/WordHunter${version}/WordHunter-${version}-x86_64.AppImage";
    hash = "sha256-ARlLOghVz9THbmeXe0vS60qiM8OTy9rxe3qam9AJ2z8=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;

    postExtract = ''
      rm "$out/usr/bin/syncthing"
      test ! -e "$out/usr/bin/syncthing"
    '';
  };

  syncthingExecutable = lib.getExe syncthing;
  wrapperProfile = ''
    export WORDHUNTER_SYNCTHING="${syncthingExecutable}"
  '';
in
(appimageTools.wrapAppImage {
  inherit pname version;

  src = appimageContents;

  extraPkgs = _pkgs: [ syncthing ];

  profile = wrapperProfile;

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
        '<launchable type="desktop-id">Word Hunter.desktop</launchable>' \
        '<launchable type="desktop-id">com.wordhunter.app.desktop</launchable>' \
      --replace-fail \
        '<binary>word-hunter-rustified</binary>' \
        '<binary>wordhunter</binary>'
  '';

  passthru = {
    inherit
      appimageContents
      src
      syncthingExecutable
      wrapperProfile
      ;
    systemSyncthing = syncthing;
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
