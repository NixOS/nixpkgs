{
  bundlerApp,
  bundlerUpdateScript,
  defaultGemConfig,
  lib,
}:

bundlerApp {
  pname = "wifi-wand";
  gemdir = ./.;
  exes = [ "wifiwand" ];

  gemConfig = defaultGemConfig // {
    wifi-wand = attrs: {
      patches = [ ./skip-os-detection.patch ];
      dontBuild = false;
    };
  };

  passthru.updateScript = bundlerUpdateScript "wifi-wand";

  meta = {
    description = "A command line interface for managing WiFi.
";
    homepage = "https://github.com/keithrbennett/wifiwand";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [ mightyiam ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "wifiwand";
  };
}
