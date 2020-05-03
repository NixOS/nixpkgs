{ stdenv, makeWrapper, fetchFromGitHub, ocaml, findlib, dune
, fix, menhir, merlin-extend, ppx_tools_versioned, utop, cppo
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-reason-${version}";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "reason";
    rev = "2860cc274b1b5b76a71d0e5190bf67a133d6f809";
    sha256 = "05wcg0gfln85spjfgsij818h2sp4y6s8bvdcwmzv0r8jblr8402b";
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
    homepage = "https://reasonml.github.io/";
    description = "Facebook's friendly syntax to OCaml";
    license = licenses.mit;
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.volth ];
  };
}
