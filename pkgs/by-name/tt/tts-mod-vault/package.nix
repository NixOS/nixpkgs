{
  lib,
  flutter341,
  makeDesktopItem,
  copyDesktopItems,
  fetchFromGitHub,
  runCommand,
  yq-go,
  nix-update-script,
  _experimental-update-script-combinators,
}:

flutter341.buildFlutterApplication (finalAttrs: {
  pname = "tts-mod-vault";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "markomijic";
    repo = "TTS-Mod-Vault";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vreamzu+jzlgzjbEro5kE5bM1k6cL6XCG6Tsv+LEiyI=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  desktopItems = [
    (makeDesktopItem {
      name = "tts_mod_vault";
      exec = "tts_mod_vault";
      icon = "tts_mod_vault";
      comment = "Tabletop Simulator Mod Vault";
      desktopName = "TTS Mod Vault";
      categories = [ "Utility" ];
    })
  ];

  nativeBuildInputs = [ copyDesktopItems ];

  preBuild = ''
    echo 'SUPABASE_URL=https://pdrmmvvtindfbpxlcdps.supabase.co' > .env
    echo 'SUPABASE_PUBLISHABLE_KEY=sb_publishable_CF6qzs1W8zd_hcVWHSCdVw__2SRB60p' >> .env
  '';

  postInstall = ''
    install -m 444 -D assets/icon/tts_mod_vault_icon.png $out/share/icons/tts_mod_vault.png
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          inherit (finalAttrs) src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "tts-mod-vault.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
    ];
  };

  meta = {
    description = "Download and backup assets for your Tabletop Simulator mods";
    homepage = "https://github.com/markomijic/TTS-Mod-Vault";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ esch ];
    mainProgram = "tts_mod_vault";
    platforms = lib.platforms.linux;
  };
})
