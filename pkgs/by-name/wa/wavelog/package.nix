{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  php,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wavelog";
<<<<<<< HEAD
  version = "2.2.1";
=======
  version = "2.1.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "wavelog";
    repo = "wavelog";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-9lrEWhGnGq4BWl57qaJ9eqWqRYfzjlATXZvP0TafJxw=";
=======
    hash = "sha256-NXQY9ICU6YVVTnXb19pFqOx4VyTfxzk1RA03RqpEOeA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
