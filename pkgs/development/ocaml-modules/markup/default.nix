{ stdenv, fetchurl, ocaml, findlib, uutf, lwt }:

stdenv.mkDerivation rec {
  pname = "ocaml-markup";
  version = "0.7.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://github.com/aantron/markup.ml/archive/${version}.tar.gz";
    sha256 = "0d3wi22v7h0iqzq8dgl0g4fj2wb67gvmbzdckacifghinrx762k3";
    };

  buildInputs = [ocaml findlib];

  installPhase = "make ocamlfind-install";
  
  propagatedBuildInputs = [uutf lwt];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/aantron/markup.ml/;
    description = "A pair of best-effort parsers implementing the HTML5 and XML specifications";
    license = licenses.bsd2;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [
      gal_bolle
      ];
  };

}
