{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-build-info,
  ppx_expect,
  uucp,
  uunf,
  uutf,
}:

buildDunePackage (finalAttrs: {
  pname = "omd";
  version = "2.0.0.alpha4";

  minimalOCamlVersion = "4.13";

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = "omd";
    tag = finalAttrs.version;
    hash = "sha256-5eZitDaNKSkLOsyPf5g5v9wdZZ3iVQGu8Ot4FHZZ3AI=";
  };

  buildInputs = [
    dune-build-info
  ];

  propagatedBuildInputs = [
    uucp
    uunf
    uutf
  ];

  doCheck = true;

  checkInputs = [
    ppx_expect
  ];

  meta = {
    description = "Extensible Markdown library and tool in OCaml";
    homepage = "https://github.com/ocaml-community/omd";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "omd";
  };
})
