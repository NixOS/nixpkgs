{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage (finalAttrs: {
  pname = "omd";
  version = "1.3.2";

  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/ocaml/omd/releases/download/${finalAttrs.version}/omd-${finalAttrs.version}.tbz";
    sha256 = "sha256-YCPhZCYx8I9njrVyWCCHnte7Wj/+53fN7evCjB+F+ts=";
  };

  preBuild = ''
    substituteInPlace src/dune --replace "bytes)" ")"
  '';

  meta = {
    description = "Extensible Markdown library and tool in OCaml";
    homepage = "https://github.com/ocaml/omd";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "omd";
  };
})
