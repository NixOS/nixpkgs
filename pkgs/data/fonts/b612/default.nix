{ stdenv, fetchzip, lib }:

let
  version = "1.008";
  pname = "b612";
in

fetchzip rec {
  name = "${pname}-font-${version}";
  url = "https://github.com/polarsys/b612/archive/${version}.zip";
  sha256 = "0r3lana1q9w3siv8czb3p9rrb5d9svp628yfbvvmnj7qvjrmfsiq";
  postFetch = ''
    mkdir -p $out/share/fonts/truetype/${pname}
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype/${pname}
  '';

  meta = with stdenv.lib; {
    homepage = http://b612-font.com/;
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
