{ocaml, findlib, stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ocaml-ipaddr-2.4.0";
  
  src = fetchurl {
    url = https://github.com/mirage/ocaml-ipaddr/archive/2.4.0.tar.gz;
    sha256 = "0g7qg35w3vzcg37798rhbx7iia83286md3gj5gdhs1qgizlg56wx";
  };

  buildInputs = [ocaml findlib];

  createFindlibDestdir = true;
  
}
