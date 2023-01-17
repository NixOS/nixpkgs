# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "2.0";
  name = "quattrocento-sans-${version}";
in (fetchzip rec {
  inherit name;

  url = "https://web.archive.org/web/20170709124317/http://www.impallari.com/media/releases/quattrocento-sans-v${version}.zip";

  sha256 = "0g8hnn92ks4y0jbizwj7yfa097lk887wqkqpqjdmc09sd2n44343";

  meta = with lib; {
    homepage = "http://www.impallari.com/quattrocentosans/";
    description = "A classic, elegant and sober sans-serif typeface";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/{fonts,doc}
    unzip -j $downloadedFile '*/QuattrocentoSans*.otf' -d $out/share/fonts/opentype
    unzip -j $downloadedFile '*/FONTLOG.txt'           -d $out/share/doc/${name}
  '';
})
