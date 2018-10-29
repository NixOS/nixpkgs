{ stdenv, fetchFromGitHub, ocaml, findlib, dune
, ppx_tools_versioned
, ounit
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-bitstring-${version}";
  version = "3.0.0";
  src = fetchFromGitHub {
    owner = "xguerin";
    repo = "bitstring";
    rev = "v${version}";
    sha256 = "0r49qax7as48jgknzaq6p9rbpmrvnmlic713wzz5bj60j5h0396f";
  };

  buildInputs = [ ocaml findlib dune ppx_tools_versioned ounit ];

  buildPhase = "jbuilder build";

  doCheck = true;
  checkPhase = "jbuilder runtest";

  inherit (dune) installPhase;

  meta = with stdenv.lib; {
    description = "This library adds Erlang-style bitstrings and matching over bitstrings as a syntax extension and library for OCaml";
    homepage = https://github.com/xguerin/bitstring;
    inherit (ocaml.meta) platforms;
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.maurer ];
  };
}
