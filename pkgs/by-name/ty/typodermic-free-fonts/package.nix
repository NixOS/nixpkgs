{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  pname = "typodermic-free-fonts";
  version = "2023a";

  src = fetchzip {
    url =
      "https://typodermicfonts.com/wp-content/uploads/2023/01/typodermic-free-fonts-2023a.zip";
    hash = "sha256-+1TPZkeiMMV0Qmk7ERgJjVVNFar9bMISbAd23H8fwFo=";
    curlOptsList = [ "--user-agent" "Mozilla/5.0" ]; # unbreak their wordpress
    stripRoot = false;
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts
    cp -a "$src/Typodermic Fonts" "$out/share/fonts/opentype"
    runHook postInstall
  '';

  meta = {
    homepage = "https://typodermicfonts.com/";
    description = "Typodermic fonts";
    maintainers = with lib.maintainers; [ ehmry ];
    license = lib.licenses.unfree // {
      fullName = "Font Software for Desktop End User License Agreement";
      url = "https://typodermicfonts.com/end-user-license-agreement/";
    }; # Font is fine for use in printing and display but cannot be embbeded.
  };
}
