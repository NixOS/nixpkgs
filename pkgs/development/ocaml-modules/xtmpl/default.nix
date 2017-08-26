{ stdenv, fetchFromGitHub, ocaml, findlib, uutf, sedlex, ppx_tools, js_of_ocaml
, re }:

if stdenv.lib.versionOlder ocaml.version "4.03"
then throw "xtmpl not supported for ocaml ${ocaml.version}"
else
stdenv.mkDerivation rec {
  name = "xtmpl-${version}";
  version = "0.16.0";
  src = fetchFromGitHub {
    owner = "zoggy";
    repo = "xtmpl";
    rev = version;
    sha256 = "1dj5b4b266y4d8q3v1g0xsivz4vkhj0gi0jis37w84xcnlgiik8k";
  };

  buildInputs = [ ocaml findlib ppx_tools js_of_ocaml ];
  propagatedBuildInputs = [ sedlex uutf re ];

  createFindlibDestdir = true;

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Xml template library for OCaml";
    homepage = https://zoggy.github.io/xtmpl/;
    license = licenses.lgpl3;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [ regnat ];
  };
}
