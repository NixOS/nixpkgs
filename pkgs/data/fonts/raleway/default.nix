{ stdenv, fetchzip }:

let
  version = "2016-08-30";
in fetchzip {
  name = "raleway-${version}";

  url = https://github.com/impallari/Raleway/archive/fa27f47b087fc093c6ae11cfdeb3999ac602929a.zip;

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*-Original.otf  -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.txt \*.md     -d $out
  '';

  sha256 = "16jr7drqg2wib2q48ajlsa7rh1jxjibl1wd4rjndi49vfl463j60";

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

    homepage = https://github.com/impallari/Raleway;
    license = stdenv.lib.licenses.ofl;

    maintainers = with stdenv.lib.maintainers; [ profpatsch ];
  };
}
