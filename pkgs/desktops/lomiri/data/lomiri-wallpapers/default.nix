{
  stdenvNoCC,
  lib,
  fetchFromGitLab,
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lomiri-wallpapers";
  version = "20.04.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-wallpapers";
    rev = finalAttrs.version;
    hash = "sha256-NttA+je2jbE0q0EXZ5PSxrpB0ijRbqpSq0N0GCWEzJk=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
  ''
  # release-specific wallpapers
  + ''
    cp -r ${lib.versions.majorMinor finalAttrs.version} $out/share/wallpapers
  ''
  # default
  + ''
    install -Dm644 {.,$out/share/wallpapers}/lomiri-default-background.png
  ''
  + ''
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Wallpapers for the Lomiri Operating Environment, gathered from people of the Ubuntu Touch / UBports community";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-wallpapers";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-wallpapers/-/blob/${finalAttrs.version}/ChangeLog";
    # On update, recheck debian/copyright for which licenses apply to the installed images
    license = with lib.licenses; [ cc-by-sa-30 ];
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.all;
  };
})
