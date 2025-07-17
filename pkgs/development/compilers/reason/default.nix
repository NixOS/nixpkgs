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
  ppx_derivers,
  dune-build-info,
}:

buildDunePackage rec {
  pname = "reason";
  version = "3.15.0";

  minimalOCamlVersion = "4.11";

  src = fetchurl {
    url = "https://github.com/reasonml/reason/releases/download/${version}/reason-${version}.tbz";
    hash = "sha256-7D0gJfQ5Hw0riNIFPmJ6haoa3dnFEyDp5yxpDgX7ZqY=";
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
  ];

  propagatedBuildInputs = [
    ppxlib
    menhirLib
  ];

  passthru.tests = {
    hello = callPackage ./tests/hello { };
  };

  meta = with lib; {
    homepage = "https://reasonml.github.io/";
    downloadPage = "https://github.com/reasonml/reason";
    description = "User-friendly programming language built on OCaml";
    license = licenses.mit;
    maintainers = [ ];
  };
}
