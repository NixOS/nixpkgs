{stdenv, fetchurl, ocaml, findlib, opam}:

stdenv.mkDerivation {
  name = "ocaml-react-1.1.0";

  src = fetchurl {
    url = http://erratique.ch/software/react/releases/react-1.1.0.tbz;
    sha256 = "1gymn8hy7ga0l9qymmb1jcnnkqvy7l2zr87xavzqz0dfi9ci8dm7";
  };

  unpackCmd = "tar xjf $src";
  buildInputs = [ocaml findlib opam];

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
