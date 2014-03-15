{stdenv, fetchurl, ocaml, findlib, ocaml_oasis}:

stdenv.mkDerivation {
  name = "ocaml-react-0.9.4";

  src = fetchurl {
    url = http://github.com/dbuenzli/react/archive/v0.9.4.tar.gz;
    sha256 = "16k0kx93kd45s7pigkzvirfsbr22xhby0y88y86p473qxzc6ngrm";
  };

  buildInputs = [ocaml findlib ocaml_oasis];

  createFindlibDestdir = true;

  configurePhase = "oasis setup && ocaml setup.ml -configure --prefix $out";
  buildPhase     = "ocaml setup.ml -build";
  installPhase   = "ocaml setup.ml -install";

  meta = {
    homepage = http://erratique.ch/software/react;
    description = "Applicative events and signals for OCaml";
    license = stdenv.lib.licenses.bsd3;
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
