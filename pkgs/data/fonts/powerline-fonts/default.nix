{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "powerline-fonts";
  version = "unstable-2018-11-11";

  src = fetchFromGitHub {
    owner = "powerline";
    repo = "fonts";
    rev = "e80e3eba9091dac0655a0a77472e10f53e754bb0";
    hash = "sha256-GGfON6Z/0czCUAGxnqtndgDnaZGONFTU9/Hu4BGDHlk=";
  };

  installPhase = ''
    runHook preInstall

    find . -name '*.otf'    -exec install -Dt $out/share/fonts/opentype {} \;
    find . -name '*.ttf'    -exec install -Dt $out/share/fonts/truetype {} \;
    find . -name '*.bdf'    -exec install -Dt $out/share/fonts/bdf      {} \;
    find . -name '*.pcf.gz' -exec install -Dt $out/share/fonts/pcf      {} \;
    find . -name '*.psf.gz' -exec install -Dt $out/share/consolefonts   {} \;

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/powerline/fonts";
    description = "Patched fonts for Powerline users";
    longDescription = ''
      Pre-patched and adjusted fonts for usage with the Powerline plugin.
    '';
    license = with licenses; [ asl20 free ofl ];
    platforms = platforms.all;
    maintainers = with maintainers; [ malyn ];
  };
}
