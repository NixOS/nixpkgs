{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, js_of_ocaml
, jsooSupport ? !(stdenv.lib.versionAtLeast ocaml.version "4.04")
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-mtime-0.8.3";

  src = fetchurl {
    url = http://erratique.ch/software/mtime/releases/mtime-0.8.3.tbz;
    sha256 = "1hfx4ny2dkw6jf3jppz0640dafl5xgn8r2si9kpwzhmibal8qrah";
  };

  unpackCmd = "tar xjf $src";

  buildInputs = [ ocaml findlib ocamlbuild opam ]
  ++ stdenv.lib.optional jsooSupport js_of_ocaml;

  buildPhase = "ocaml pkg/build.ml native=true native-dynlink=true jsoo=${if jsooSupport then "true" else "false"}";

  installPhase = "opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR";

  meta = {
    description = "Monotonic wall-clock time for OCaml";
    homepage = http://erratique.ch/software/mtime;
    inherit (ocaml.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    license = stdenv.lib.licenses.bsd3;
  };
}
