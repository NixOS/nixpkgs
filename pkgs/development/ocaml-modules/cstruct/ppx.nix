{ lib, buildDunePackage, cstruct, sexplib, ppxlib, stdlib-shims
, ounit, cppo, ppx_sexp_conv, cstruct-unix, cstruct-sexp
, fetchpatch
}:

if !lib.versionAtLeast (cstruct.version or "1") "3"
then cstruct
else

buildDunePackage {
  pname = "ppx_cstruct";
  inherit (cstruct) version src useDune2 meta;

  minimumOCamlVersion = "4.07";

  # prevent ANSI escape sequences from messing up the test cases
  # https://github.com/mirage/ocaml-cstruct/issues/283
  patches = [
    (fetchpatch {
      url = "https://github.com/mirage/ocaml-cstruct/pull/285/commits/60dfed98b4c34455bf339ac60e2ed5ef05feb48f.patch";
      sha256 = "1x9i62nrlfy9l44vb0a7qjfrg2wyki4c8nmmqnzwpcbkgxi3q6n5";
    })
  ];

  propagatedBuildInputs = [ cstruct ppxlib sexplib stdlib-shims ];

  # disable until ppx_sexp_conv uses ppxlib 0.20.0 (or >= 0.16.0)
  # since the propagation of the older ppxlib breaks the ppx_cstruct
  # build.
  doCheck = false;
  checkInputs = [ ounit cppo ppx_sexp_conv cstruct-sexp cstruct-unix ];
}
