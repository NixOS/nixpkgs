{ stdenv, fetchurl, zlib, ocaml, findlib, ocamlbuild, zarith, ncurses }:

assert stdenv.lib.versionAtLeast ocaml.version "3.12";

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.02"
  then {
    version = "1.11";
    url = http://forge.ocamlcore.org/frs/download.php/1618/cryptokit-1.11.tar.gz;
    sha256 = "1c1vn15lf2b5a8nfa2v2brxm7bwby540nf6q0vkndgkq5qcw96j8";
    inherit zarith;
  } else {
    version = "1.10";
    url = http://forge.ocamlcore.org/frs/download.php/1493/cryptokit-1.10.tar.gz;
    sha256 = "1k2f2ixm7jcsgrzn9lz1hm9qqgq71lk9lxy3v3cwsd8xdrj3jrnv";
    zarith = null;
  };
in

stdenv.mkDerivation rec {
  name = "cryptokit-${version}";
  inherit (param) version;

  src = fetchurl {
    inherit (param) url sha256;
  };

  buildInputs = [ zlib ocaml findlib ocamlbuild ncurses ];
  propagatedBuildInputs = [ param.zarith ];

  buildFlags = "setup.data build";

  preBuild = "mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/cryptokit";

  meta = {
    homepage = http://pauillac.inria.fr/~xleroy/software.html;
    description = "A library of cryptographic primitives for OCaml";
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
