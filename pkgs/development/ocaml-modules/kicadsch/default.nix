{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage (finalAttrs: {
  pname = "kicadsch";
  version = "0.9.0";

  minimalOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/jnavila/plotkicadsch/releases/download/v${finalAttrs.version}/plotkicadsch-${finalAttrs.version}.tbz";
    sha256 = "sha256-B+vnEPyd3SUzviTdNoyvYk0p7Hrg/XTJm8KxsY8A4jQ=";
  };

  meta = {
    description = "OCaml library for exporting Kicad Sch files to SVG pictures";
    homepage = "https://github.com/jnavila/plotkicadsch";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ leungbk ];
  };
})
