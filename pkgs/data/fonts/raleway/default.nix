{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "raleway-${version}";
  version = "2016-08-30";

  src = fetchFromGitHub {
    owner = "impallari";
    repo = "Raleway";
    rev = "fa27f47b087fc093c6ae11cfdeb3999ac602929a";
    sha256 = "1i6a14ynm29gqjr7kfk118v69vjpd3g4ylwfvhwa66xax09jkhlr";
  };
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp "$src/fonts/OTF v3.000 Fontlab"/*.otf $out/share/fonts/opentype
    find -type f -maxdepth 1 -exec cp "{}" $out/ \;
  '';

  meta = {
    description = "Raleway is an elegant sans-serif typeface family";

    longDescription = ''
      Initially designed by Matt McInerney as a single thin weight, it was
      expanded into a 9 weight family by Pablo Impallari and Rodrigo Fuenzalida
      in 2012 and iKerned by Igino Marini. In 2013 the Italics where added.

      It is a display face and the download features both old style and lining
      numerals, standard and discretionary ligatures, a pretty complete set of
      diacritics, as well as a stylistic alternate inspired by more geometric
      sans-serif typefaces than its neo-grotesque inspired default character
      set.

      It also has a sister display family, Raleway Dots.
    '';

    homepage = src.meta.homepage;
    license = stdenv.lib.licenses.ofl;

    maintainers = with stdenv.lib.maintainers; [ profpatsch ];
  };
}
