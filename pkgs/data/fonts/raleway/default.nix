{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "raleway";
  version = "2016-08-30";

  src = fetchFromGitHub {
    owner = "impallari";
    repo = "Raleway";
    rev = "fa27f47b087fc093c6ae11cfdeb3999ac602929a";
    hash = "sha256-mcIpE+iqG6M43I5TT95oV+5kNgphunmyxC+Jaj0JysQ=";
  };

  installPhase = ''
    runHook preInstall

    find . -name "*-Original.otf" -exec install -Dt $out/share/fonts/opentype {} \;

    runHook postInstall
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

    homepage = "https://github.com/impallari/Raleway";
    license = lib.licenses.ofl;

    maintainers = with lib.maintainers; [ Profpatsch ];
  };
}
