{ stdenv, makeWrapper, buildOcaml, fetchFromGitHub,
  ocaml, opam, jbuilder, menhir, merlin_extend, ppx_tools_versioned, utop }:

buildOcaml rec {
  name = "reason";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "reason";
    rev = "68a4124c772ee25c4729b005c8643851b1e17b92";
    sha256 = "01v17m94ds98qk727mwpyx0a362zdf9s8x1fh8gp9jd9v3n6bc2d";
  };

  propagatedBuildInputs = [ menhir merlin_extend ppx_tools_versioned ];

  buildInputs = [ makeWrapper opam jbuilder utop menhir ];

  buildFlags = [ "build" ]; # do not "make tests" before reason lib is installed

  createFindlibDestdir = true;

  installPhase = ''
    for p in reason rtop
    do
      ${jbuilder.installPhase} $p.install
    done

    wrapProgram $out/bin/rtop \
      --prefix PATH : "${utop}/bin" \
      --set OCAMLPATH $out/lib/ocaml/${ocaml.version}/site-lib:$OCAMLPATH
  '';

  meta = with stdenv.lib; {
    homepage = https://reasonml.github.io/;
    description = "Facebook's friendly syntax to OCaml";
    license = licenses.mit;
    maintainers = [ maintainers.volth ];
  };
}
