{stdenv, fetchurl, ocaml, findlib}:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "3.12";

stdenv.mkDerivation {

  name = "ocaml-fix-20130611";

  src = fetchurl {
    url = http://gallium.inria.fr/~fpottier/fix/fix-20130611.tar.gz;
    sha256 = "1phlqcs1nb93x9cf0w0hnq2ck4dmn71zm4mxf60w96vb9yb9qzp0";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = http://gallium.inria.fr/~fpottier/fix/;
    description = "A simple OCaml module for computing the least solution of a system of monotone equations";
    license = licenses.cecill-c;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
