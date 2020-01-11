{ stdenv, makeWrapper, fetchFromGitHub, ocaml, findlib, dune
, menhir, merlin-extend, ppx_tools_versioned, utop, cppo
, ocaml_lwt
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-reason-${version}";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "reason";
    rev = "aea245a43eb44034d2fccac7028b640a437af239";
    sha256 = "0ff7rjxbsg9zkq6sxlm9bkx7yk8x2cvras7z8436msczgd1wmmyf";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ menhir merlin-extend ppx_tools_versioned ];

  buildInputs = [ ocaml findlib dune cppo utop menhir ];

  buildFlags = [ "build" ]; # do not "make tests" before reason lib is installed

  inherit (dune) installPhase;

  postInstall = ''
    wrapProgram $out/bin/rtop \
      --prefix PATH : "${utop}/bin" \
      --prefix CAML_LD_LIBRARY_PATH : "${ocaml_lwt}/lib/ocaml/${ocaml.version}/site-lib" \
      --prefix OCAMLPATH : "$out/lib/ocaml/${ocaml.version}/site-lib"
  '';

  meta = with stdenv.lib; {
    homepage = https://reasonml.github.io/;
    description = "Facebook's friendly syntax to OCaml";
    license = licenses.mit;
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.volth ];
  };
}
