{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  menhir,
  menhirLib,
  ounit,
  ezjsonm,
  mustache-cli,
}:
import ./base.nix {
  inherit
    buildDunePackage
    fetchFromGitHub
    menhirLib
    ezjsonm
    ounit
    ;
  doCheck = true;
  nativeBuildInputs = [
    menhir
    mustache-cli
  ];
}
// {
  meta = {
    description = "Mustache logic-less templates in OCaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      vbgl
      momeemt
    ];
    homepage = "https://github.com/rgrinberg/ocaml-mustache";
  };
}
