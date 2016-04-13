{stdenv, fetchurl, ocaml, findlib, camlp4}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

stdenv.mkDerivation {
  name = "camomile-0.8.5";

  src = fetchurl {
    url = https://github.com/yoriyuki/Camomile/releases/download/rel-0.8.5/camomile-0.8.5.tar.bz2;
    sha256 = "003ikpvpaliy5hblhckfmln34zqz0mk3y2m1fqvbjngh3h2np045";
  };

  buildInputs = [ocaml findlib camlp4];

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/yoriyuki/Camomile/tree/master/Camomile;
    description = "A comprehensive Unicode library for OCaml";
    license = stdenv.lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
