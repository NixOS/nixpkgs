{ lib, fetchFromGitHub }:

let
  pname = "inriafonts";
  version = "1.200";
in fetchFromGitHub rec {
  name = "${pname}-${version}";
  owner = "BlackFoundry";
  repo = "InriaFonts";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -m444 -Dt $out/share/fonts/truetype fonts/*/TTF/*.ttf
    install -m444 -Dt $out/share/fonts/opentype fonts/*/OTF/*.otf
  '';
  sha256 = "0wrwcyycyzvgvgnlmwi1ncdvwb8f6bbclynd1105rsyxgrz5dd70";

  meta = with lib; {
    homepage = https://black-foundry.com/work/inria;
    description = "Inria Sans and Inria Serif";
    longDescription = ''
      Inria Sans and Inria Serif are the two members of a type family
      design for the communication of Inria, the French national institute
      dedicated to numeric research. The Institut needed a font
      showing its values at the crossroad of humanity, technology,
      excellence and creativity. Black[Foudry] created a humanist
      typeface with a unapologetically contemporary design as the
      Sans-serif part and a more rational axis and drawing for the
      serif. Both members comes in 3 weights with matching italics.
    '';
    license = licenses.ofl;
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.all;
  };
}
