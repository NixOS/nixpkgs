{ stdenv, fetchzip, lib }:

let
  version = "1.003";
  pname = "b612";
in

fetchzip rec {
  name = "${pname}-font-${version}";
  url = "http://git.polarsys.org/c/${pname}/${pname}.git/snapshot/${pname}-bd14fde2544566e620eab106eb8d6f2b7fb1347e.zip";
  sha256 = "07gadk9b975k69pgw9gj54qx8d5xvxphid7wrmv4cna52jyy4464";
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
