{
  appimageTools,
  fetchurl,
  lib,
  makeDesktopItem,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "tusk";
  version = "0.23.0";

  desktopItem = makeDesktopItem {
    name = "tusk";
    exec = "tusk";
    icon = fetchurl {
      url = "https://raw.githubusercontent.com/klaussinani/tusk/v${finalAttrs.version}/static/Icon.png";
      sha256 = "1jqclyrjgg6hir45spg75plfmd8k9nrsrzw3plbcg43s5m1qzihb";
    };
    desktopName = "tusk";
    genericName = "Evernote desktop app";
    categories = [ "Application" ];
  };

  src = fetchurl {
    url = "https://github.com/klaussinani/tusk/releases/download/v${finalAttrs.version}/tusk-${finalAttrs.version}-x86_64.AppImage";
    sha256 = "02q7wsnhlyq8z74avflrm7805ny8fzlmsmz4bmafp4b4pghjh5ky";
  };

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  extraInstallCommands = ''
    mkdir "$out/share"
    ln -s "${finalAttrs.desktopItem}/share/applications" "$out/share/"
  '';

  meta = {
    description = "Refined Evernote desktop app";
    longDescription = ''
      Tusk is an unofficial, featureful, open source, community-driven, free Evernote app used by people in more than 140 countries. Tusk is indicated by Evernote as an alternative client for Linux environments trusted by the open source community.
    '';
    homepage = "https://klaussinani.github.io/tusk/";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "tusk";
  };
})
