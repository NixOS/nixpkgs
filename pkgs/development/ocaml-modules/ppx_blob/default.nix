{ lib, fetchurl, buildDunePackage, ocaml, alcotest, ppxlib }:

buildDunePackage rec {
  pname = "ppx_blob";
  version = "0.7.2";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/johnwhitington/${pname}/releases/download/${version}/ppx_blob-${version}.tbz";
    sha256 = "00haz1cmplk3j9ysh6j656zrldy60585fmlndmfhpd5332mxrfdw";
  };

  nativeCheckInputs = [ alcotest ];
  propagatedBuildInputs = [ ppxlib ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = with lib; {
    homepage = "https://github.com/johnwhitington/ppx_blob";
    description = "OCaml ppx to include binary data from a file as a string";
    license = licenses.unlicense;
  };
}
