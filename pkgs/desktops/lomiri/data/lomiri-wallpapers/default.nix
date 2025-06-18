{
  stdenvNoCC,
  lib,
  fetchFromGitLab,
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lomiri-wallpapers";
  version = "20.04.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-wallpapers";
    rev = finalAttrs.version;
    hash = "sha256-n8+vY+MPVqW6s5kSo4aEtGZv1AsjB3nNEywbmcNWfhI=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share

    # release-specific wallpapers
    cp -r ${lib.versions.majorMinor finalAttrs.version} $out/share/wallpapers
    rm $out/share/wallpapers/.placeholder

    # eternal hardwired fallback/default
    install -Dm644 {.,$out/share/wallpapers}/warty-final-ubuntu.png
    ln -s warty-final-ubuntu.png $out/share/wallpapers/lomiri-default-background.png

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Wallpapers for the Lomiri Operating Environment, gathered from people of the Ubuntu Touch / UBports community";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-wallpapers";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-wallpapers/-/blob/${finalAttrs.version}/ChangeLog";
    # On update, recheck debian/copyright for which licenses apply to the installed images
    license = with licenses; [ cc-by-sa-30 ];
    teams = [ teams.lomiri ];
    platforms = platforms.all;
  };
})
