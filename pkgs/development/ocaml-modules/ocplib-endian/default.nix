{ stdenv, fetchzip, ocaml, findlib, cppo }:

let version = "0.8"; in

stdenv.mkDerivation {
  name = "ocaml-ocplib-endian-${version}";

  src = fetchzip {
    url = "https://github.com/OCamlPro/ocplib-endian/archive/${version}.tar.gz";
    sha256 = "12xjvzw245mj4s02dgi4k2sx5gam7wxi4mbxmz6k18zg64n48yjd";
  };

  buildInputs = [ ocaml findlib cppo ];

  createFindlibDestdir = true;

  meta = {
    description = "Optimised functions to read and write int16/32/64";
    homepage = https://github.com/OCamlPro/ocplib-endian;
    license = stdenv.lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
