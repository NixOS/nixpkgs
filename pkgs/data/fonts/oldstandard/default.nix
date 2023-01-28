# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "2.2";
  name = "oldstandard-${version}";
in (fetchzip rec {
  inherit name;

  url = "https://github.com/akryukov/oldstand/releases/download/v${version}/${name}.otf.zip";

  sha256 = "1qwfsyp51grr56jcnkkmnrnl3r20pmhp9zh9g88kp64m026cah6n";

  meta = with lib; {
    homepage = "https://github.com/akryukov/oldstand";
    description = "An attempt to revive a specific type of Modern style of serif typefaces";
    maintainers = with maintainers; [ raskin ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}).overrideAttrs (_: {
  postFetch = ''
    unzip $downloadedFile
    install -m444 -Dt $out/share/fonts/opentype *.otf
    install -m444 -Dt $out/share/doc/${name}    FONTLOG.txt
  '';
})
