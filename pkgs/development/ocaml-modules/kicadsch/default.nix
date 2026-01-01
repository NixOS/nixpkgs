{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  pname = "kicadsch";
  version = "0.9.0";

  minimalOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/jnavila/plotkicadsch/releases/download/v${version}/plotkicadsch-${version}.tbz";
    sha256 = "sha256-B+vnEPyd3SUzviTdNoyvYk0p7Hrg/XTJm8KxsY8A4jQ=";
  };

<<<<<<< HEAD
  meta = {
    description = "OCaml library for exporting Kicad Sch files to SVG pictures";
    homepage = "https://github.com/jnavila/plotkicadsch";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ leungbk ];
=======
  meta = with lib; {
    description = "OCaml library for exporting Kicad Sch files to SVG pictures";
    homepage = "https://github.com/jnavila/plotkicadsch";
    license = licenses.isc;
    maintainers = with maintainers; [ leungbk ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
