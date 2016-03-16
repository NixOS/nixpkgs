{ stdenv, fetchzip, ocaml, findlib }:

stdenv.mkDerivation {
  name = "ocaml-ppx_tools-0.99.2";
  src = fetchzip {
    url = https://github.com/alainfrisch/ppx_tools/archive/ppx_tools_0.99.2.tar.gz;
    sha256 = "1m09r2sjcb37i4dyhpbk9n2wxkcvpib6bvairsird91fm9w0vqw7";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    description = "Tools for authors of ppx rewriters";
    homepage = http://www.lexifi.com/ppx_tools;
    license = licenses.mit;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = with maintainers; [ vbgl ];
  };
}
