{ stdenv, fetchurl, buildDunePackage, alcotest, ocaml-migrate-parsetree }:

buildDunePackage rec {
  pname = "ppx_blob";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/johnwhitington/${pname}/releases/download/${version}/ppx_blob-${version}.tbz";
    sha256 = "1xmslk1mwdzhy1bydgsjlcb7h544c39hvxa8lywp8w72gaggjl16";
  };

  buildInputs = [ alcotest ocaml-migrate-parsetree ];
  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/johnwhitington/ppx_blob;
    description = "OCaml ppx to include binary data from a file as a string";
    license = licenses.unlicense;
  };
}
