{stdenv, fetchurl, ocaml}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "0.9.2";
in

stdenv.mkDerivation {
  name = "ocaml-react-${version}";

  src = fetchurl {
    url = "http://erratique.ch/software/react/releases/react-${version}.tbz";
    sha256 = "0fiaxzfxv8pc82d31jz85zryz06k84is0l3sn5g0di5mpc5falxr";
  };

  buildInputs = [ocaml];

  buildCommand = ''
    export INSTALLDIR=$out/lib/ocaml/${ocaml_version}/site-lib/react
    tar xjf $src
    cd react-*
    substituteInPlace src/META --replace '+react' $INSTALLDIR
    chmod +x build
    ./build 
    ./build install
  '';

  meta = {
    homepage = http://erratique.ch/software/react;
    description = "Applicative events and signals for OCaml";
    license = "BSD";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
