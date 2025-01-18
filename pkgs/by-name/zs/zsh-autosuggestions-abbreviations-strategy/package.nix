{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zsh-autosuggestions-abbreviations-strategy";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "olets";
    repo = "zsh-autosuggestions-abbreviations-strategy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j2Xx8EWcSRntY7gqK9X1/rn3siZgNdL7ht4CyfAA+yY=";
  };

  installPhase = ''
    runHook preInstall

    install *.zsh -Dt "$out/share/zsh/site-functions/"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Have zsh-autosuggestions suggest your zsh-abbr abbreviations";
    homepage = "https://github.com/olets/zsh-autosuggestions-abbreviations-strategy";
    license = licenses.mit;
    maintainers = with maintainers; [ llakala ];
    platforms = platforms.all;
  };
})
