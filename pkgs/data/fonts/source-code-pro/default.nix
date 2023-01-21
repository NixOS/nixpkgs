# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "2.038";
in (fetchzip {
  name = "source-code-pro-${version}";

  url = "https://github.com/adobe-fonts/source-code-pro/releases/download/${version}R-ro%2F1.058R-it%2F1.018R-VAR/OTF-source-code-pro-${version}R-ro-1.058R-it.zip";

  sha256 = "027cf62zj27q7l3d4sqzdfgz423lzysihdg8cvmkk6z910a1v368";

  meta = {
    description = "Monospaced font family for user interface and coding environments";
    maintainers = with lib.maintainers; [ relrod ];
    platforms = with lib.platforms; all;
    homepage = "https://adobe-fonts.github.io/source-code-pro/";
    license = lib.licenses.ofl;
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';
})
