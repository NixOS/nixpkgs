{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  php,
}:

stdenvNoCC.mkDerivation rec {
  pname = "wavelog";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "wavelog";
    repo = pname;
    tag = version;
    hash = "sha256-BYCRqb27QWOo74w3O6tfZGEDF3UInsgshsIm9uxOm+8=";
  };

  installPhase = ''
    runHook preInstall
    cp -R . $out
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Webbased Amateur Radio Logging Software";
    license = lib.licenses.mit;
    homepage = "https://www.wavelog.org";
    platforms = php.meta.platforms;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
