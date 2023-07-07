{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "dancing-script";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "impallari";
    repo = "DancingScript";
    rev = "f7f54bc1b8836601dae8696666bfacd306f77e34";
    hash = "sha256-B9oAZFPH3dG/Nt5FfKfFVJYtfUKGK0AXNkQHRC7IgdU=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype fonts/ttf/*.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Dancing Script";
    longDescription = "A lively casual script where the letters bounce and change size slightly.";
    homepage = "https://github.com/impallari/DancingScript";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ wdavidw ];
  };
}
