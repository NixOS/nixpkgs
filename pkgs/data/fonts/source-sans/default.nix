{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "source-sans";
<<<<<<< HEAD
  version = "3.052";

  src = fetchzip {
    url = "https://github.com/adobe-fonts/source-sans/archive/${version}R.zip";
    hash = "sha256-yzbYy/ZS1GGlgJW+ARVWF4tjFqmMq7x+YqSQnojtQBs=";
=======
  version = "3.046";

  src = fetchzip {
    url = "https://github.com/adobe-fonts/source-sans/archive/${version}R.zip";
    hash = "sha256-nBLEK+T5n1CdZK2zvCWIhF2MxPmiAwL9l55a55yHtgU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 OTF/*.otf -t $out/share/fonts/opentype
    install -Dm444 TTF/*.ttf -t $out/share/fonts/truetype
<<<<<<< HEAD
    install -Dm444 VF/*.otf -t $out/share/fonts/variable
=======
    install -Dm444 VAR/*.otf -t $out/share/fonts/variable
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://adobe-fonts.github.io/source-sans/";
    description = "Sans serif font family for user interface environments";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
