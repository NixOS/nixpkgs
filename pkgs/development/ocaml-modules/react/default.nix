{stdenv, fetchurl, ocaml, findlib, opam}:

stdenv.mkDerivation {
  name = "ocaml-react-1.0.1";

  src = fetchurl {
    url = "http://erratique.ch/software/react/releases/react-1.0.1.tbz";
    sha256 = "007c9kzl0i6xvxnqj9jny4hgm28v9a1i079q53vl5hfb5f7h1mda";
  };

  unpackCmd = "tar xjf $src";
  buildInputs = [ocaml findlib opam];

  createFindlibDestdir = true;

  configurePhase = "ocaml pkg/git.ml";
  buildPhase     = "ocaml pkg/build.ml native=true native-dynlink=true";
  installPhase   = ''
    opam-installer --script --prefix=$out react.install > install.sh
    sh install.sh
  '';

  meta = with stdenv.lib; {
    homepage = http://erratique.ch/software/react;
    description = "Applicative events and signals for OCaml";
    license = licenses.bsd3;
    platforms = ocaml.meta.platforms;
    maintainers = with maintainers; [ z77z vbmithr ];
  };
}
