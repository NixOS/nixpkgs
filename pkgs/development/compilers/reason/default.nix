{ stdenv, makeWrapper, fetchFromGitHub, ocaml, findlib, dune_2
, fix, menhir, merlin-extend, ppx_tools_versioned, utop, cppo
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-reason-${version}";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "reason";
    rev = "6017d6dd930f4989177c3f7c3c20cffbaabaa49a";
    sha256 = "17wkcl3r0ckhlki9fk0mcwbnd7kpkqm1h0xjw2j2x1097n470df0";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ menhir merlin-extend ppx_tools_versioned ];

  buildInputs = [ ocaml findlib dune_2 cppo fix utop menhir ];

  buildFlags = [ "build" ]; # do not "make tests" before reason lib is installed

  installPhase = ''
    dune install --prefix=$out --libdir=$OCAMLFIND_DESTDIR
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
