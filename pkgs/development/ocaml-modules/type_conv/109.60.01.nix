{stdenv, fetchurl, ocaml, findlib, camlp4}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

assert stdenv.lib.versionOlder "4.00" ocaml_version;

stdenv.mkDerivation {
  name = "ocaml-type_conv-109.60.01";

  src = fetchurl {
    url = https://github.com/janestreet/type_conv/archive/109.60.01.tar.gz;
    sha256 = "0lpxri68glgq1z2pp02rp45cb909xywbff8d4idljrf6fzzil2zx";
  };

  buildInputs = [ocaml findlib camlp4];

  createFindlibDestdir = true;

  meta = {
    homepage = "http://forge.ocamlcore.org/projects/type-conv/";
    description = "Support library for OCaml preprocessor type conversions";
    license = stdenv.lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [ z77z ];
  };
}
