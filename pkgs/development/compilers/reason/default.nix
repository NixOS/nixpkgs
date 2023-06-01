{ lib, callPackage, stdenv, makeWrapper, fetchurl, ocaml, findlib, dune_3
, ncurses
, fix, menhir, menhirLib, menhirSdk, merlin-extend, ppxlib, utop, cppo, ppx_derivers
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-reason";
  version = "3.8.2";

  src = fetchurl {
    url = "https://github.com/reasonml/reason/releases/download/${version}/reason-${version}.tbz";
    sha256 = "sha256-etzEXbILje+CrfJxIhH7jthEMoSJdS6O33QoG8HrLvI=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    makeWrapper
    menhir
    ocaml
    menhir
    cppo
    dune_3
    findlib
  ];

  buildInputs = [
    fix
    menhirSdk
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
