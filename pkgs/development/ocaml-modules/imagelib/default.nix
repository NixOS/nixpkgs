{ lib, fetchurl, buildDunePackage, ocaml
, decompress, stdlib-shims, alcotest
}:

buildDunePackage rec {
  minimumOCamlVersion = "4.07";
  version = "20210511";
  pname = "imagelib";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/rlepigre/ocaml-imagelib/releases/download/${version}/imagelib-${version}.tbz";
    sha256 = "1cb94ea3731dc994c205940c9434543ce3f2470cdcb2e93a3e02ed793e80d480";
  };

  propagatedBuildInputs = [ decompress stdlib-shims ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ alcotest ];

  meta = {
    description = "Image formats such as PNG and PPM in OCaml";
    homepage = "https://github.com/rlepigre/ocaml-imagelib";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "imagetool";
  };
}
