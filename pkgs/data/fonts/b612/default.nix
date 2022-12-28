{ lib, fetchFromGitHub }:

fetchFromGitHub rec {
  pname = "b612";
  version = "1.008";

  owner = "polarsys";
  repo = "b612";
  rev = version;

  postFetch = ''
    mkdir -p $out/share/fonts/truetype

    mv $out/fonts/ttf/*.ttf $out/share/fonts/truetype

    shopt -s extglob dotglob
    rm -rf $out/!(share)
    shopt -u extglob dotglob
  '';

  hash = "sha256-aJ3XzWQauPsWwEDAHT2rD9a8RvLv1kqU3krFXprmypk=";

  meta = with lib; {
    homepage = "https://b612-font.com/";
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
