{ stdenv, makeWrapper, fetchFromGitHub, ocaml, findlib, dune
, menhir, merlin-extend, ppx_tools_versioned, utop, cppo
, ocaml_lwt
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-reason-${version}";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "reason";
    rev = "ea207004e021efef5a92ecd011d9d5b9b16bbded";
    sha256 = "0cdjy7sw15rlk63prrwy8lavqrz8fqwsgwr19ihvj99x332r98kk";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ menhir merlin-extend ppx_tools_versioned ];

  buildInputs = [ ocaml findlib dune cppo utop menhir ];

  buildFlags = [ "build" ]; # do not "make tests" before reason lib is installed

  inherit (dune) installPhase;

  postInstall = ''
    wrapProgram $out/bin/rtop \
      --prefix PATH : "${utop}/bin" \
      --set CAML_LD_LIBRARY_PATH ${ocaml_lwt}/lib/ocaml/${ocaml.version}/site-lib:$CAML_LD_LIBRARY_PATH \
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
