{ stdenv, makeWrapper, fetchFromGitHub, ocaml, findlib, dune
, menhir, merlin_extend, ppx_tools_versioned, utop
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-reason-${version}";
  version = "3.3.7";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "reason";
    rev = "4d20e5b535c29c5ef1283e65958b32996e449e5a";
    sha256 = "0f3pb61wg58g8f3wcnp1h4gpmnwmp7bq0cnqdfwldmh9cs0dqyfk";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ menhir merlin_extend ppx_tools_versioned ];

  buildInputs = [ ocaml findlib dune utop menhir ];

  buildFlags = [ "build" ]; # do not "make tests" before reason lib is installed

  inherit (dune) installPhase;

  postInstall = ''
    wrapProgram $out/bin/rtop \
      --prefix PATH : "${utop}/bin" \
      --set OCAMLPATH $out/lib/ocaml/${ocaml.version}/site-lib:$OCAMLPATH
  '';

  meta = with stdenv.lib; {
    homepage = https://reasonml.github.io/;
    description = "Facebook's friendly syntax to OCaml";
    license = licenses.mit;
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.volth ];
  };
}
