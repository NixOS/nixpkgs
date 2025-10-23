{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  php,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wavelog";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "wavelog";
    repo = "wavelog";
    tag = finalAttrs.version;
    hash = "sha256-NXQY9ICU6YVVTnXb19pFqOx4VyTfxzk1RA03RqpEOeA=";
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
