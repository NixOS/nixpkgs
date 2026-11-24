{
  lib,
  appimageTools,
  dwarfs,
  fetchurl,
  makeWrapper,
  nix-update-script,
  runCommand,
}:

appimageTools.wrapAppImage (finalAttrs: {
  pname = "vita3k";
  version = "4403";

  src = fetchurl {
    url = "https://github.com/Vita3K/Vita3K-builds/releases/download/${finalAttrs.version}/Vita3K-x86_64.AppImage";
    hash = "sha256-we6p/+v9N6VeC7p538+qf//pi6+l2Pk3qL52jv0t8Jk=";
  };

  contents =
    runCommand "${finalAttrs.pname}-${finalAttrs.version}-extracted"
      {
        nativeBuildInputs = [ dwarfs ];
        strictDeps = true;
      }
      ''
        mkdir "$out"
        dwarfsextract -i ${finalAttrs.src} -o "$out" --skip-devices --skip-specials
        chmod go-w "$out"
      '';

  nativeBuildInputs = [ makeWrapper ];

  extraPkgs = pkgs: [ pkgs.sdl3 ];

  extraInstallCommands = ''
    install -Dm444 ${finalAttrs.contents}/org.vita3k.vita3k.desktop -t "$out/share/applications"
    substituteInPlace "$out/share/applications/org.vita3k.vita3k.desktop" \
      --replace-fail "Exec=Vita3K" "Exec=vita3k"
    install -Dm444 ${finalAttrs.contents}/org.vita3k.vita3k.svg -t "$out/share/icons/hicolor/scalable/apps"
    wrapProgram "$out/bin/vita3k" \
      --set APPIMAGE 1 \
      --unset QT_PLUGIN_PATH \
      --unset QML2_IMPORT_PATH
  '';

  passthru = {
    inherit (finalAttrs) src;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Experimental PlayStation Vita emulator";
    homepage = "https://vita3k.org/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ekisu ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "vita3k";
  };
})
