{ lib, callPackage, stdenv, makeWrapper, fetchurl, ocaml, findlib, dune_2
, fix, menhir, menhirLib, menhirSdk, merlin-extend, ppxlib, utop, cppo, ppx_derivers
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-reason";
  version = "3.8.0";

  src = fetchurl {
    url = "https://github.com/reasonml/reason/releases/download/${version}/reason-${version}.tbz";
    sha256 = "sha256:0yc94m3ddk599crg33yxvkphxpy54kmdsl599c320wvn055p4y4l";
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
