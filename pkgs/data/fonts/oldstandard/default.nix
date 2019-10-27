{ lib, fetchzip }:

let
  version = "2.2";
in fetchzip rec {
  name = "oldstandard-${version}";

  url = "https://github.com/akryukov/oldstand/releases/download/v${version}/${name}.otf.zip";

  postFetch = ''
    unzip $downloadedFile
    install -m444 -Dt $out/share/fonts/opentype *.otf
    install -m444 -Dt $out/share/doc/${name}    FONTLOG.txt
  '';

  sha256 = "1qwfsyp51grr56jcnkkmnrnl3r20pmhp9zh9g88kp64m026cah6n";

  meta = with lib; {
    homepage = https://github.com/akryukov/oldstand;
    description = "An attempt to revive a specific type of Modern style of serif typefaces";
    maintainers = with maintainers; [ raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
