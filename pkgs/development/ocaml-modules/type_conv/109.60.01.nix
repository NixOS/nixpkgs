{stdenv, fetchurl, ocaml, findlib, camlp4}:

if !stdenv.lib.versionAtLeast ocaml.version "4.00"
|| stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "type_conv-109.60.01 is not available for OCaml ${ocaml.version}" else

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
