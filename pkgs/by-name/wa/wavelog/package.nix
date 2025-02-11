{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  php,
}:

stdenvNoCC.mkDerivation rec {
  pname = "wavelog";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "wavelog";
    repo = pname;
    tag = version;
    hash = "sha256-njolFPtcNzF/AGchJd8BwdJDFPe4+6xgRBi1JKo4r0k=";
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
