{ stdenv, fetchFromGitHub, ocaml, findlib
, ocamlbuild, topkg, opam
, uri, xmlm, omd, ezjsonm }:

stdenv.mkDerivation rec {
  version = "2.2.0";
  name = "ocaml-cow-${version}";

  src = fetchFromGitHub {
    owner  = "mirage";
    repo   = "ocaml-cow";
    rev    = "v${version}";
    sha256 = "0snhabg7rfrrcq2ksr3qghiawd61cw3y4kp6rl7vs87j4cnk3kr2";
  };

  createFindlibDestdir = true;

  buildInputs = [ ocaml opam ocamlbuild findlib topkg ];
  propagatedBuildInputs = [ xmlm uri ezjsonm omd ];

  inherit (topkg) buildPhase installPhase;

  meta = with stdenv.lib; {
    description = "Caml on the Web";
    longDescription = ''
      Caml on the Web (COW) is a set of parsers and syntax extensions to let you manipulate HTML, CSS, XML, JSON and Markdown directly from OCaml code.
    '';
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    inherit (ocaml.meta) platforms;
  };
}
