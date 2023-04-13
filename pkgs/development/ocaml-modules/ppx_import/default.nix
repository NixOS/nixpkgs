{ lib
, fetchurl
, buildDunePackage
, ocaml
, ounit
, ppx_deriving
, ppx_sexp_conv
, ppxlib
, version ? if lib.versionAtLeast ocaml.version "4.11" then "1.10.0" else "1.9.1"
}:

let param = {
  "1.9.1" = {
    sha256 = "sha256-0bSY4u44Ds84XPIbcT5Vt4AG/4PkzFKMl9CDGFZyIdI=";
  };
  "1.10.0" = {
    sha256 = "sha256-MA8sf0F7Ch1wJDL8E8470ukKx7KieWyjWJnJQsqBVW8=";
  };
}."${version}"; in

lib.throwIfNot (lib.versionAtLeast ppxlib.version "0.24.0")
  "ppx_import is not available with ppxlib-${ppxlib.version}"

buildDunePackage rec {
  pname = "ppx_import";
  inherit version;

  minimalOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/ocaml-ppx/ppx_import/releases/download/${version}/ppx_import-${version}.tbz";
    inherit (param) sha256;
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
