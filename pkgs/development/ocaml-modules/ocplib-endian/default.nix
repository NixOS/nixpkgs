{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, cppo }:

let version = "1.0"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ocplib-endian-${version}";

  src = fetchzip {
    url = "https://github.com/OCamlPro/ocplib-endian/archive/${version}.tar.gz";
    sha256 = "0s1ld3kavz892b8awyxyg1mr98h2g61gy9ci5v6yb49bsii6wicw";
  };

  buildInputs = [ ocaml findlib ocamlbuild cppo ];

  createFindlibDestdir = true;

  meta = {
    description = "Optimised functions to read and write int16/32/64";
    homepage = https://github.com/OCamlPro/ocplib-endian;
    license = stdenv.lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
