{
  lib,
  appimageTools,
  makeWrapper,
  nix-update-script,
  fetchurl,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "vita3k";
  version = "4065";

  src = fetchurl {
    url = "https://github.com/Vita3K/Vita3K-builds/releases/download/${finalAttrs.version}/Vita3K-x86_64.AppImage";
    sha256 = "sha256-jgypzFZgQeBvtuEuw51ex6r7tOqTYaIJAE3JzDRMcWI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  extraPkgs = pkgs: [ pkgs.sdl3 ];

  extraInstallCommands = ''
    install -Dm444 ${finalAttrs.contents}/vita3k.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/vita3k.desktop \
      --replace-fail "Exec=Vita3K" "Exec=vita3k"
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share
    wrapProgram $out/bin/vita3k \
      --set APPIMAGE 1 \
      --unset QT_PLUGIN_PATH \
      --unset QML2_IMPORT_PATH
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Experimental PlayStation Vita emulator";
    homepage = "https://vita3k.org/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ekisu ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "vita3k";
  };
})
