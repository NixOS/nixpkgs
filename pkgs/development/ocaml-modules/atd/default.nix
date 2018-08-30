{ stdenv, menhir, easy-format, ocaml, findlib, fetchFromGitHub, jbuilder, which, biniou, yojson }:

stdenv.mkDerivation rec {
  version = "2.0.0";

  name = "ocaml${ocaml.version}-atd-${version}";

  src = fetchFromGitHub {
    owner = "mjambon";
    repo = "atd";
    rev = version;
    sha256 = "0alzmk97rxg7s6irs9lvf89dy9n3r769my5n4j9p9qyigcdgjaia";
  };

  createFindlibDestdir = true;

  buildInputs = [ which jbuilder ocaml findlib menhir ];
  propagatedBuildInputs = [ easy-format biniou yojson ];

  buildPhase = "jbuilder build";
  inherit (jbuilder) installPhase;

  meta = with stdenv.lib; {
    homepage = https://github.com/mjambon/atd;
    description = "Syntax for cross-language type definitions";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aij jwilberding ];
  };
}
