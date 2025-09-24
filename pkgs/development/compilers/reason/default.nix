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

let
  param =
    if lib.versionAtLeast ppxlib.version "0.36" then
      {
        version = "3.16.0";
        hash = "sha256-R7DkOn00jiqFBlirS+xaT7u5/U/z7IocGBZRFVjFNk4=";
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
