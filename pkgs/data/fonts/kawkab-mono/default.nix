# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

(fetchzip {
  name = "kawkab-mono-20151015";

  url = "http://makkuk.com/kawkab-mono/downloads/kawkab-mono-0.1.zip";

  sha256 = "1vfrb7xs817najplncg7zl9j5yxj8qnwb7aqm2v9p9xwafa4d2yd";

  meta = {
    description = "An arab fixed-width font";
    homepage = "https://makkuk.com/kawkab-mono/";
    license = lib.licenses.ofl;
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';
})
