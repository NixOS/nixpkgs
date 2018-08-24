{ stdenv, makeWrapper, buildOcaml, fetchFromGitHub, fetchpatch,
  ocaml, opam, jbuilder, menhir, merlin_extend, ppx_tools_versioned, utop }:

buildOcaml rec {
  name = "reason";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "reason";
    rev = "fefe5e4db3a54a7946c2220ee037dd2f407011c9";
    sha256 = "1x0dbacgq9pa36zgzwrc0gm14wbb6v27y9bf7wcwk55a1ck0am18";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/facebook/reason/commit/e02f9bfb73f9cbbc00f0fa6215b107c6f70a22c2.patch";
      sha256 = "18slimrsp79fgz2dbfx3sls70ybyj37b99fgykx3chc66i4yd53f";
    })
  ];

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
