{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "JuliaMono-ttf";
<<<<<<< HEAD
  version = "0.051";
=======
  version = "0.049";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchzip {
    url = "https://github.com/cormullion/juliamono/releases/download/v${version}/${pname}.tar.gz";
    stripRoot = false;
<<<<<<< HEAD
    hash = "sha256-JdoCblRW9Vih7zQyvTb/VXhZJJDNV0sPDfTQ+wRKotE=";
=======
    hash = "sha256-UTiuWbRUJVGEuqNj2EU6VBb8Y4FO08TA2Nk7cjsjmuM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    mv *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "A monospaced font for scientific and technical computing";
    longDescription = ''
      JuliaMono is a monospaced typeface designed for use in text editing
      environments that require a wide range of specialist and technical Unicode
      characters. It was intended as a fun experiment to be presented at the
      2020 JuliaCon conference in Lisbon, Portugal (which of course didn’t
      physically happen in Lisbon, but online).
    '';
    maintainers = with maintainers; [ suhr ];
    platforms = with platforms; all;
    homepage = "https://juliamono.netlify.app/";
    license = licenses.ofl;
  };
}
