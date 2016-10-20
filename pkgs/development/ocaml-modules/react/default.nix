{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam }:

stdenv.mkDerivation {
  name = "ocaml-react-1.2.0";

  src = fetchurl {
    url = http://erratique.ch/software/react/releases/react-1.2.0.tbz;
    sha256 = "0knhgbngphv5sp1yskfd97crf169qhpc0igr6w7vqw0q36lswyl8";
  };

  unpackCmd = "tar xjf $src";
  buildInputs = [ ocaml findlib ocamlbuild opam ];

  createFindlibDestdir = true;

  configurePhase = "ocaml pkg/git.ml";
  buildPhase     = "ocaml pkg/build.ml native=true native-dynlink=true";

  installPhase   =
  let ocamlVersion = (builtins.parseDrvName (ocaml.name)).version;
  in
   ''
    opam-installer --script --prefix=$out react.install > install.sh
    sed -i s!lib/react!lib/ocaml/${ocamlVersion}/site-lib/react! install.sh
    sh install.sh
  '';

  meta = with stdenv.lib; {
    homepage = http://erratique.ch/software/react;
    description = "Applicative events and signals for OCaml";
    license = licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [ z77z vbmithr gal_bolle];
  };
}
