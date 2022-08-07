{ lib, fetchzip }:

let
  version = "2.1";
in
  fetchzip rec {
    name = "galatia-sil-${version}";

    url = "https://software.sil.org/downloads/r/galatia/GalatiaSIL-${version}.zip";

    postFetch = ''
      mkdir -p $out/share/{doc,fonts}
      unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
      unzip -j $downloadedFile \*OFL.txt \*OFL-FAQ.txt \*FONTLOG.txt -d "$out/share/doc/${name}"
    '';

    sha256 = "sha256-zLL/7LMcJul2LilhEafpvm+tiYlgv1y1jj85VvG+wiI=";

    meta = with lib; {
      homepage = "https://software.sil.org/galatia";
      description = "Font designed to support Biblical Polytonic Greek";
      longDescription = ''
        Galatia SIL, designed to support Biblical Polytonic Greek, is a Unicode 3.1 font released under the SIL Open Font License. The font supports precomposed characters rather than decomposed characters. Thus, you must use a keyboard that outputs NFC encoding (precomposed).
      '';
      license = licenses.ofl;
      platforms = platforms.all;
      maintainers = [ maintainers.kmein ];
    };
  }
