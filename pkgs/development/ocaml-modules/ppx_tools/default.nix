{ stdenv, fetchzip, ocaml, findlib }:

stdenv.mkDerivation {
  name = "ocaml-ppx_tools-4.02.3";
  src = fetchzip {
    url = https://github.com/alainfrisch/ppx_tools/archive/v4.02.3.tar.gz;
    sha256 = "0varkd93hgrarwwkrjp2yy735q7jqzba75sskyanmvkb576wpcxv";
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
