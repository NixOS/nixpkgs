{ lib, callPackage, stdenv, makeWrapper, fetchFromGitHub, ocaml, findlib, dune_2
, fix, menhir, menhirLib, menhirSdk, merlin-extend, ppxlib, utop, cppo, ppx_derivers
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-reason";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "reason";
    rev = "daa11255cb4716ce1c370925251021bd6e3bd974";
    sha256 = "0m6ldrci1a4j0qv1cbwh770zni3al8qxsphl353rv19f6rblplhs";
  };

  nativeBuildInputs = [
    makeWrapper
    menhir
  ];

  buildInputs = [
    cppo
    dune_2
    findlib
    fix
    menhir
    menhirSdk
    ocaml
    ppxlib
    utop
  ];

  propagatedBuildInputs = [
    menhirLib
    merlin-extend
    ppx_derivers
  ];

  buildFlags = [ "build" ]; # do not "make tests" before reason lib is installed

  installPhase = ''
    dune install --prefix=$out --libdir=$OCAMLFIND_DESTDIR
    wrapProgram $out/bin/rtop \
      --prefix PATH : "${utop}/bin" \
      --prefix CAML_LD_LIBRARY_PATH : "$CAML_LD_LIBRARY_PATH" \
      --prefix OCAMLPATH : "$OCAMLPATH:$OCAMLFIND_DESTDIR"
  '';

  passthru.tests = {
    hello = callPackage ./tests/hello { };
  };

  meta = with lib; {
    homepage = "https://reasonml.github.io/";
    downloadPage = "https://github.com/reasonml/reason";
    description = "Facebook's friendly syntax to OCaml";
    license = licenses.mit;
    inherit (ocaml.meta) platforms;
    maintainers = with maintainers; [ ];
  };
}
