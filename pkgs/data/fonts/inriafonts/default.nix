{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  pname = "inriafonts";
  version = "1.200";

  src = fetchFromGitHub {
    owner = "BlackFoundry";
    repo = "InriaFonts";
    rev = "v${version}";
    sha256 = "06775y99lyh6hj5hzvrx56iybdck8a8xfqkipqd5c4cldg0a9hh8";
  };

  meta = with lib; {
    homepage = "https://black-foundry.com/work/inria";
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
