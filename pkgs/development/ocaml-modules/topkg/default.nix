{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, result, opam }:

if !stdenv.lib.versionAtLeast ocaml.version "4.01"
then throw "topkg is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-topkg-${version}";
  version = "0.8.1";

  src = fetchurl {
    url = "http://erratique.ch/software/topkg/releases/topkg-${version}.tbz";
    sha256 = "18rrh6fmf708z7dd30amljmcgaypj3kk49jrmrj68r4wnw8004j8";
  };

  nativeBuildInputs = [ opam ];
  buildInputs = [ ocaml findlib ocamlbuild ];
  propagatedBuildInputs = [ result ];

  unpackCmd = "tar xjf ${src}";
  buildPhase = "ocaml -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib/ pkg/pkg.ml build";
  createFindlibDestdir = true;
  installPhase = "opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR";

  meta = {
    homepage = http://erratique.ch/software/topkg;
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    description = "A packager for distributing OCaml software";
    inherit (ocaml.meta) platforms;
  };
}
