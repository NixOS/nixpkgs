{stdenv, fetchurl, zlib, ocaml, findlib, ncurses}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

assert stdenv.lib.versionAtLeast ocaml_version "3.12";

stdenv.mkDerivation {
  name = "cryptokit-1.10";

  src = fetchurl {
    url = http://forge.ocamlcore.org/frs/download.php/1493/cryptokit-1.10.tar.gz;
    sha256 = "1k2f2ixm7jcsgrzn9lz1hm9qqgq71lk9lxy3v3cwsd8xdrj3jrnv";
  };

  buildInputs = [zlib ocaml findlib ncurses];

  buildFlags = "setup.data build";

  preBuild = "mkdir -p $out/lib/ocaml/${ocaml_version}/site-lib/cryptokit";

  meta = {
    homepage = "http://pauillac.inria.fr/~xleroy/software.html";
    description = "A library of cryptographic primitives for OCaml";
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
