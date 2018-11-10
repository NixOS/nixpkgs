{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, cppo, ppx_tools, ppx_deriving, result }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-visitors-20171124";

  src = fetchurl {
    url = http://gallium.inria.fr/~fpottier/visitors/visitors-20171124.tar.gz;
    sha256 = "04047k2v0pgwcdkgw7jk4955pgil0nj2ji0zfhmlqrdbinyfqzac";
  };

  buildInputs = [ ocaml findlib ocamlbuild cppo ];
  propagatedBuildInputs = [ ppx_tools ppx_deriving result ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://gitlab.inria.fr/fpottier/visitors;
    license = licenses.lgpl21;
    description = "An OCaml syntax extension (technically, a ppx_deriving plugin) which generates object-oriented visitors for traversing and transforming data structures";
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.marsam ];
  };
}
