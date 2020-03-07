{ stdenv, fetchurl, zlib, ocaml, findlib, ocamlbuild, zarith, ncurses }:

assert stdenv.lib.versionAtLeast ocaml.version "3.12";

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.02"
  then {
    version = "1.14";
    url = https://github.com/xavierleroy/cryptokit/archive/release114.tar.gz;
    sha256 = "0wkh72idkb7dahiwyl94hhbq27cc7x9fnmxkpnbqli6wi8wd7d05";
    inherit zarith;
  } else {
    version = "1.10";
    url = http://forge.ocamlcore.org/frs/download.php/1493/cryptokit-1.10.tar.gz;
    sha256 = "1k2f2ixm7jcsgrzn9lz1hm9qqgq71lk9lxy3v3cwsd8xdrj3jrnv";
    zarith = null;
  };
in

stdenv.mkDerivation {
  pname = "cryptokit";
  inherit (param) version;

  src = fetchurl {
    inherit (param) url sha256;
  };

  buildInputs = [ ocaml findlib ocamlbuild ncurses ];
  propagatedBuildInputs = [ param.zarith zlib ];

  buildFlags = [ "setup.data" "build" ];

  preBuild = "mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs";

  meta = {
    homepage = http://pauillac.inria.fr/~xleroy/software.html;
    description = "A library of cryptographic primitives for OCaml";
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.maggesi
    ];
  };
}
