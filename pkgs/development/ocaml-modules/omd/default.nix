{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  uunf,
  uutf,
  uucp,
  dune-build-info,
  ppx_expect,
}:

buildDunePackage (finalAttrs: {
  pname = "omd";
  version = "2.0.0.alpha4";

  minimalOCamlVersion = "4.13";

  src = fetchFromGitHub {
    repo = "omd";
    owner = "ocaml-community";
    sha256 = "sha256-5eZitDaNKSkLOsyPf5g5v9wdZZ3iVQGu8Ot4FHZZ3AI=";
    rev = finalAttrs.version;
  };

  preBuild = ''
    substituteInPlace src/dune --replace "bytes)" ")"
  '';

  buildInputs = [
    dune-build-info
    uunf
    uucp
    uutf
  ];
  doCheck = true;
  checkInputs = [ ppx_expect ];

  meta = {
    description = "Extensible Markdown library and tool in OCaml";
    homepage = "https://github.com/ocaml/omd";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "omd";
  };
})
