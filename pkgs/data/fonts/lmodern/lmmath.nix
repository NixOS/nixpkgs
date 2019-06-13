{ lib, fetchzip }:

fetchzip {
  name = "lmmath-0.903";

  url = "http://www.gust.org.pl/projects/e-foundry/lm-math/download/lmmath0903otf";

  postFetch = ''
    unzip $downloadedFile

    mkdir -p $out/texmf-dist/fonts/opentype
    mkdir -p $out/share/fonts/opentype

    cp *.{OTF,otf} $out/texmf-dist/fonts/opentype/lmmath-regular.otf
    cp *.{OTF,otf} $out/share/fonts/opentype/lmmath-regular.otf

    ln -s -r $out/texmf* $out/share/
  '';

  sha256 = "19821d4vbd6z20jzsw24zh0hhwayglhrfw8larg2w6alhdqi7rln";

  meta = {
    description = "Latin Modern font";
  };
}

