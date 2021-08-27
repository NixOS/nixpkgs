{ lib, fetchzip }:

let
  version = "1.2";
in fetchzip {
  name = "hasklig-${version}";

  url = "https://github.com/i-tu/Hasklig/releases/download/v${version}/Hasklig-${version}.zip";

  postFetch = ''
    unzip $downloadedFile
    install -m444 -Dt $out/share/fonts/opentype OTF/*.otf
  '';

  sha256 = "sha256-8lY1m0P1qQIbR4e7kX68jVoKZmEfPWNwK3AFLoaBEak=";

  meta = with lib; {
    homepage = "https://github.com/i-tu/Hasklig";
    description = "A font with ligatures for Haskell code based off Source Code Pro";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ davidrusu Profpatsch ];
  };
}
