{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  php,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wavelog";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "wavelog";
    repo = "wavelog";
    tag = finalAttrs.version;
    hash = "sha256-8DjRJ9QJ2M4lfw6coveXR/aayNeLY9fICVP2uBixcBc=";
  };

  installPhase = ''
    runHook preInstall
    cp -R . $out
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Webbased Amateur Radio Logging Software";
    homepage = "https://www.wavelog.org";
    downloadPage = "https://github.com/wavelog/wavelog";
    changelog = "https://github.com/wavelog/wavelog/releases/tag/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = php.meta.platforms;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
})
