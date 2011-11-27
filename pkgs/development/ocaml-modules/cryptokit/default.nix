{stdenv, fetchurl, zlib, ocaml, findlib, ncurses}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "1.5";
in

stdenv.mkDerivation {
  name = "cryptokit-${version}";

  src = fetchurl {
    url = "http://forge.ocamlcore.org/frs/download.php/639/" +
          "cryptokit-${version}.tar.gz";
    sha256 = "1r5kbsbsicrbpdrdim7h8xg2b1a8qg8sxig9q6cywzm57r33lj72";
  };

  buildInputs = [zlib ocaml findlib ncurses];

  buildFlags = "setup.data build";

  preBuild = "ensureDir $out/lib/ocaml/${ocaml_version}/site-lib/cryptokit";

  meta = {
    homepage = "http://pauillac.inria.fr/~xleroy/software.html";
    description = "A library of cryptographic primitives for OCaml";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
