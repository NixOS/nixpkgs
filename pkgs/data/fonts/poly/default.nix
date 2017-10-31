{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "poly";

  regular = fetchurl {
    # Finally a mirror that has a sha256 that doesn't change.
    url = "https://googlefontdirectory.googlecode.com/hg-history/d7441308e589c9fa577f920fc4152fa32477a267/poly/src/Poly-Regular.otf";
    sha256 = "1mxp2lvki6b1h7r9xcj1ld0g4z5y3dmsal85xam4yr764zpjzaiw";
  };

  italic = fetchurl {
    # Finally a mirror that has a sha256 that doesn't change.
    url = "https://googlefontdirectory.googlecode.com/hg-history/d7441308e589c9fa577f920fc4152fa32477a267/poly/src/Poly-Italic.otf";
    sha256 = "1chzcy3kyi7wpr4iq4aj1v24fq1wwph1v5z96dimlqcrnvm66h2l";
  };

  buildInputs = [unzip];

  sourceRoot = ".";

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp ${regular} $out/share/fonts/opentype/Poly-Regular.otf
    cp ${italic} $out/share/fonts/opentype/Poly-Italic.otf
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "11d7ldryfxi0wzfrg1bhw23a668a44vdb8gggxryvahmp5ahmq2h";

  meta = {
    description = "Medium contrast serif font";
    longDescription = ''
      With short ascenders and a very high x-height, Poly is efficient in small
      sizes. Thanks to its careful balance between the x-height and glyph widths,
      it allows more economy and legibility than standard web serifs, even in
      small sizes. The aglutinative language for which it was designed contains
      very long words. The goal was to develop a typeface that would tolerate
      cramped tracking and that would increase the number of letters on a single
      line. Poly is a Unicode typeface family that supports Open Type features
      and languages that use the Latin script and its variants.
    '';
    homepage = http://www.fontsquirrel.com/fonts/poly;
    license = stdenv.lib.licenses.ofl;
    maintainers = with stdenv.lib.maintainers; [ relrod ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
