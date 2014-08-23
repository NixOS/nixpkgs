{stdenv, fetchurl, ocaml, findlib}:

stdenv.mkDerivation {
  name = "ocaml-typeconv-109.60.01";

  src = fetchurl {
    url = https://github.com/janestreet/type_conv/archive/109.60.01.tar.gz;
    sha256 = "0lpxri68glgq1z2pp02rp45cb909xywbff8d4idljrf6fzzil2zx";
  };

  buildInputs = [ocaml findlib ]; 

  createFindlibDestdir = true;

  meta = {
    homepage = "http://forge.ocamlcore.org/projects/type-conv/";
    description = "Support library for OCaml preprocessor type conversions";
    license = stdenv.lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms;
    maintainers = with stdenv.lib.maintainers; [ z77z ];
  };
}
