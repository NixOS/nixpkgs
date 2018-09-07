{ stdenv, makeWrapper, fetchFromGitHub, ocaml, findlib, jbuilder
, menhir, merlin_extend, ppx_tools_versioned, utop
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-reason-${version}";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "reason";
    rev = "fefe5e4db3a54a7946c2220ee037dd2f407011c9";
    sha256 = "1x0dbacgq9pa36zgzwrc0gm14wbb6v27y9bf7wcwk55a1ck0am18";
  };

  propagatedBuildInputs = [ menhir merlin_extend ppx_tools_versioned ];

  buildInputs = [ makeWrapper ocaml findlib jbuilder utop menhir ];

  buildFlags = [ "build" ]; # do not "make tests" before reason lib is installed

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
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.volth ];
  };
}
