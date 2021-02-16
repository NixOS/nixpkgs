{ lib, fetchurl, buildDunePackage
, decompress, stdlib-shims, alcotest
}:

buildDunePackage rec {
  minimumOCamlVersion = "4.07";
  version = "20200929";
  pname = "imagelib";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/rlepigre/ocaml-imagelib/releases/download/ocaml-imagelib_${version}/imagelib-ocaml-imagelib_${version}.tbz";
    sha256 = "1wyq4xxj0dxwafbcmd7jylsd8w1gbyl7j4ak6jbq1n0ardwmpwca";
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
