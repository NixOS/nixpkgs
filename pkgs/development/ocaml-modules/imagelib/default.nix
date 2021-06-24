{ lib, fetchurl, buildDunePackage
, decompress, stdlib-shims, alcotest
}:

buildDunePackage rec {
  minimumOCamlVersion = "4.07";
  version = "20210402";
  pname = "imagelib";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/rlepigre/ocaml-imagelib/releases/download/${version}/imagelib-${version}.tbz";
    sha256 = "b3c8ace02b10b36b6c60b3ce3ae0b9109d4a861916ec320c59cc1194f4cc86e3";
  };

  propagatedBuildInputs = [ decompress stdlib-shims ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "Image formats such as PNG and PPM in OCaml";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/rlepigre/ocaml-imagelib";
  };
}
