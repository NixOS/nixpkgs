{ stdenv, makeWrapper, fetchFromGitHub, ocaml, findlib, dune
, fix, menhir, merlin-extend, ppx_tools_versioned, utop, cppo
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-reason-${version}";
  version = "3.5.4";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "reason";
    rev = "e3287476e5c3f0cbcd9dc7ab18d290f81f4afa0c";
    sha256 = "02p5d1x6lr7jp9mvgvsas3nnq3a97chxp5q6rl07n5qm61d5b4dl";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ menhir merlin-extend ppx_tools_versioned ];

  buildInputs = [ ocaml findlib dune cppo fix utop menhir ];

  buildFlags = [ "build" ]; # do not "make tests" before reason lib is installed

  inherit (dune) installPhase;

  postInstall = ''
    wrapProgram $out/bin/rtop \
      --prefix PATH : "${utop}/bin" \
      --prefix CAML_LD_LIBRARY_PATH : "$CAML_LD_LIBRARY_PATH" \
      --prefix OCAMLPATH : "$OCAMLPATH:$OCAMLFIND_DESTDIR"
  '';

  meta = with stdenv.lib; {
    homepage = https://reasonml.github.io/;
    description = "Facebook's friendly syntax to OCaml";
    license = licenses.mit;
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.volth ];
  };
}
