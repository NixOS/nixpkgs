{ lib
, fetchurl
, buildDunePackage
, ounit
, ppx_deriving
, ppx_sexp_conv
, ppxlib
}:

lib.throwIfNot (lib.versionAtLeast ppxlib.version "0.24.0")
  "ppx_import is not available with ppxlib-${ppxlib.version}"

buildDunePackage rec {
  pname = "ppx_import";
  version = "1.9.1";

  useDune2 = true;

  minimalOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/ocaml-ppx/ppx_import/releases/download/${version}/ppx_import-${version}.tbz";
    sha256 = "1li1f9b1i0yhjy655k74hgzhd05palz726zjbhwcy3iqxvi9id6i";
  };

  propagatedBuildInputs = [
    ppxlib
  ];

  checkInputs = [
    ounit
    ppx_deriving
    ppx_sexp_conv
  ];

  doCheck = true;

  meta = {
    description = "A syntax extension for importing declarations from interface files";
    license = lib.licenses.mit;
    homepage = "https://github.com/ocaml-ppx/ppx_import";
  };
}
