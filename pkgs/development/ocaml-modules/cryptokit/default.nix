{stdenv, fetchurl, zlib, ocaml, findlib, ncurses}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "1.7";
in

stdenv.mkDerivation {
  name = "cryptokit-${version}";

  src = fetchurl {
    url = "http://forge.ocamlcore.org/frs/download.php/1166/" +
          "cryptokit-${version}.tar.gz";
    sha256 = "56a8c0339c47ca3cf43c8881d5b519d3bff68bc8a53267e9c5c9cbc9239600ca";
  };

  buildInputs = [zlib ocaml findlib ncurses];

  buildFlags = "setup.data build";

  preBuild = "mkdir -p $out/lib/ocaml/${ocaml_version}/site-lib/cryptokit";

  meta = {
    homepage = "http://pauillac.inria.fr/~xleroy/software.html";
    description = "A library of cryptographic primitives for OCaml";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
