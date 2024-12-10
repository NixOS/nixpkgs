{
  lib,
  fetchurl,
  buildDunePackage,
  ocaml,
  decompress,
  stdlib-shims,
  alcotest,
}:

buildDunePackage rec {
  minimalOCamlVersion = "4.08";
  version = "20221222";
  pname = "imagelib";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/rlepigre/ocaml-imagelib/releases/download/${version}/imagelib-${version}.tbz";
    hash = "sha256-BQ2TVxGlpc6temteK84TKXpx0MtHZSykL/TjKN9xGP0=";
  };

  propagatedBuildInputs = [
    decompress
    stdlib-shims
  ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "Image formats such as PNG and PPM in OCaml";
    homepage = "https://github.com/rlepigre/ocaml-imagelib";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "imagetool";
  };
}
