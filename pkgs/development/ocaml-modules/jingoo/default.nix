{ stdenv, fetchFromGitHub, ocaml, findlib, pcre, uutf }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "jingoo is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-jingoo-${version}";
  version = "1.2.18";

  src = fetchFromGitHub {
    owner = "tategakibunko";
    repo = "jingoo";
    rev = "v${version}";
    sha256 = "0gciiysrjy5r4yiisc41k4h0p530yawzqnr364xg8fdkk444fgkn";
  };

  buildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ pcre uutf ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/tategakibunko/jingoo;
    description = "OCaml template engine almost compatible with jinja2";
    license = licenses.mit;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
