{ stdenv, fetchzip, ocaml, findlib }:

stdenv.mkDerivation {
  name = "ocaml-ppx_tools-5.0+4.02";
  src = fetchzip {
    url = https://github.com/alainfrisch/ppx_tools/archive/5.0+4.02.0.tar.gz;
    sha256 = "16drjk0qafjls8blng69qiv35a84wlafpk16grrg2i3x19p8dlj8";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    description = "Tools for authors of ppx rewriters";
    homepage = http://www.lexifi.com/ppx_tools;
    license = licenses.mit;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [ vbgl ];
  };
}
