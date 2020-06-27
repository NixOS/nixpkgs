{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  version = "1.008";
  pname = "b612-font";

  src = fetchFromGitHub {
    owner = "polarsys";
    repo = "b612";
    rev = version;
    sha256 = "0j4cwr9j782gs3l5c2hy5nvjng2qdrvgalbq3m13phsf8gql485v";
  };

  meta = with lib; {
    homepage = "http://b612-font.com/";
    description = "Highly legible font family for use on aircraft cockpit screens";
    longDescription = ''
      B612 is the result of a research project initiated by Airbus. The font
      was designed by Nicolas Chauveau and Thomas Paillot (intactile DESIGN) with the
      support of Jean‑Luc Vinot (ENAC). Prior research by Jean‑Luc Vinot (DGAC/DSNA)
      and Sylvie Athènes (Université de Toulouse III). The challenge for the
      "Aeronautical Font" was to improve the display of information on the cockpit
      screens, in particular in terms of legibility and comfort of reading, and to
      optimize the overall homogeneity of the cockpit.

      Intactile DESIGN was hired to work on the design of eight typographic
      variants of the font. This one, baptized B612 in reference to the
      imaginary asteroid of the aviator Saint‑Exupéry, benefited from a complete
      hinting on all the characters.
      '';
    license = with licenses; [ ofl epl10 bsd3 ] ;
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.all;
  };
}
