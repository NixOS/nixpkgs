{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, uutf, lwt }:

stdenv.mkDerivation rec {
  pname = "markup";
  version = "0.7.5";
  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchzip {
    url = "https://github.com/aantron/markup.ml/archive/${version}.tar.gz";
    sha256 = "09qm73m6c6wjh51w61vnfsnis37m28cf1r6hnkr3bbg903ahwbp5";
    };

  buildInputs = [ ocaml findlib ocamlbuild lwt ];

  installPhase = "make ocamlfind-install";

  propagatedBuildInputs = [ uutf ];

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
