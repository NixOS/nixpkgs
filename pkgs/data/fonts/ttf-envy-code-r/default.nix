{ lib, fetchzip }:

let
  pname = "ttf-envy-code-r";
  version = "PR7";
in fetchzip {
  name = "${pname}-0.${version}";

  url = "http://download.damieng.com/fonts/original/EnvyCodeR-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*.txt -d "$out/share/doc/${pname}"
  '';

  sha256 = "0x0r07nax68cmz7490x2crzzgdg4j8fg63wppcmjqm0230bggq2z";

  meta = with lib; {
    homepage = "https://damieng.com/blog/tag/envy-code-r";
    description = "Free scalable coding font by DamienG";
    license = licenses.unfree;
    maintainers = [ ];
  };
}
