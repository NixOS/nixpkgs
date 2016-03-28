{stdenv, fetchurl, zlib, ocaml, findlib, ncurses}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

assert stdenv.lib.versionAtLeast ocaml_version "3.12";

stdenv.mkDerivation {
  name = "cryptokit-1.9";

  src = fetchurl {
    url = http://forge.ocamlcore.org/frs/download.php/1166/cryptokit-1.9.tar.gz;
    sha256 = "1jh0jqiwkjy9qplnfcm5r25zdgyk36sxb0c87ks3rjj7khrw1a2n";
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
