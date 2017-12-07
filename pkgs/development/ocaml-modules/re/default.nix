{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, ounit }:

stdenv.mkDerivation rec {
  name = "ocaml-re-${version}";
  version = "1.7.1";

  src = fetchzip {
    url = "https://github.com/ocaml/ocaml-re/archive/${version}.tar.gz";
    sha256 = "1z2z4fjrpdbl0q50fdxvy3746w1vx6ybxcb0k81hqm1342nylbmw";
  };

  buildInputs = [ ocaml findlib ocamlbuild ounit ];

  configurePhase = "ocaml setup.ml -configure --prefix $out --enable-tests";
  buildPhase = "ocaml setup.ml -build";
  doCheck = true;
  checkPhase = "ocaml setup.ml -test";
  installPhase = "ocaml setup.ml -install";

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/ocaml/ocaml-re;
    platforms = ocaml.meta.platforms or [];
    description = "Pure OCaml regular expressions, with support for Perl and POSIX-style strings";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
