{ lib, callPackage, stdenv, makeWrapper, fetchurl, ocaml, findlib, dune_2
, ncurses
, fix, menhir, menhirLib, menhirSdk, merlin-extend, ppxlib, utop, cppo, ppx_derivers
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-reason";
  version = "3.8.1";

  src = fetchurl {
    url = "https://github.com/reasonml/reason/releases/download/${version}/reason-${version}.tbz";
    sha256 = "sha256-v827CfYrTBCPJubcOAQxYT5N5LBl348UNk7+Ss6o5BQ=";
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
  ] ++ lib.optional (lib.versionOlder ocaml.version "4.07") ncurses;

  propagatedBuildInputs = [
    menhirLib
    merlin-extend
    ppx_derivers
  ];

  buildFlags = [ "build" ]; # do not "make tests" before reason lib is installed

  installPhase = ''
    runHook preInstall
    dune install --prefix=$out --libdir=$OCAMLFIND_DESTDIR
    wrapProgram $out/bin/rtop \
      --prefix PATH : "${utop}/bin" \
      --prefix CAML_LD_LIBRARY_PATH : "$CAML_LD_LIBRARY_PATH" \
      --prefix OCAMLPATH : "$OCAMLPATH:$OCAMLFIND_DESTDIR"
    runHook postInstall
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
