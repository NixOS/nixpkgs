{stdenv, fetchurl, ocaml, findlib, opam}:

let
  pname = "cmdliner";
  version = "0.9.8";
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

assert stdenv.lib.versionAtLeast ocaml_version "3.12";

stdenv.mkDerivation {

  name = "ocaml-${pname}-${version}";

  src = fetchurl {
    url = "http://erratique.ch/software/${pname}/releases/${pname}-${version}.tbz";
    sha256 = "0hdxlkgiwjml9dpaa80282a8350if7mc1m6yz2mrd7gci3fszykx";
  };

  unpackCmd = "tar xjf $src";
  buildInputs = [ ocaml findlib opam ];

  createFindlibDestdir = true;

  configurePhase = "ocaml pkg/git.ml";
  buildPhase     = "ocaml pkg/build.ml native=true native-dynlink=true";
  installPhase   = ''
    opam-installer --script --prefix=$out ${pname}.install > install.sh
    sh install.sh
    ln -s $out/lib/${pname} $out/lib/ocaml/${ocaml_version}/site-lib/
  '';

  meta = with stdenv.lib; {
    homepage = http://erratique.ch/software/cmdliner;
    description = "An OCaml module for the declarative definition of command line interfaces";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
