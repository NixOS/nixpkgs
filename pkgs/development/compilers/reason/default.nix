{
  lib,
  callPackage,
  buildDunePackage,
  fetchurl,
  fix,
  menhir,
  menhirLib,
  menhirSdk,
  merlin-extend,
  ppxlib,
  cppo,
  cmdliner,
  dune-build-info,
}:

let
  param =
    if lib.versionAtLeast ppxlib.version "0.36" then
      {
        version = "3.17.3";
        hash = "sha256-AcRZG4ITrYxxtunx0YDqvSANRBk27if+n5lka3X5hlw=";
      }
    else
      {
        version = "3.15.0";

        hash = "sha256-7D0gJfQ5Hw0riNIFPmJ6haoa3dnFEyDp5yxpDgX7ZqY=";
      };
in

buildDunePackage rec {
  pname = "reason";
  inherit (param) version;

  minimalOCamlVersion = "4.11";

  src = fetchurl {
    url = "https://github.com/reasonml/reason/releases/download/${version}/reason-${version}.tbz";
    inherit (param) hash;
  };

  nativeBuildInputs = [
    menhir
    cppo
  ];

  buildInputs = [
    dune-build-info
    fix
    menhirSdk
    merlin-extend
  ]
  ++ lib.optional (lib.versionAtLeast version "3.17") cmdliner;

  propagatedBuildInputs = [
    ppxlib
    menhirLib
  ];

  passthru.tests = {
    hello = callPackage ./tests/hello { };
  };

  meta = {
    homepage = "https://reasonml.github.io/";
    downloadPage = "https://github.com/reasonml/reason";
    description = "User-friendly programming language built on OCaml";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
