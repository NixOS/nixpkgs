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
  version = "1.3.2";
  minimalOCamlVersion = "4.03";
  src = fetchFromGitHub {
    repo = "omd";
    owner = "ocaml-community";
    sha256 =
      {
        "2.0.0.alpha4" = "sha256-5eZitDaNKSkLOsyPf5g5v9wdZZ3iVQGu8Ot4FHZZ3AI=";
        "1.3.2" = "sha256-PeEWqHgdajSxoi5G4TfyV1S3RRfilYlcttTxQ0xhyE4=";
      }
      ."${finalAttrs.version}";

    rev = finalAttrs.version;
  };

  preBuild = lib.optionalString (!lib.versionAtLeast finalAttrs.version "2.0.0.alpha4") ''
    substituteInPlace src/dune --replace "bytes)" ")"
  '';

  buildInputs = lib.optionals (lib.versionAtLeast finalAttrs.version "2.0.0.alpha4") [
    dune-build-info
    uunf
    uucp
    uutf
  ];
  doCheck = lib.versionAtLeast finalAttrs.version "2.0.0.alpha4";
  checkInputs = lib.optionals (lib.versionAtLeast finalAttrs.version "2.0.0.alpha4") [ ppx_expect ];

  meta = {
    description = "Extensible Markdown library and tool in OCaml";
    homepage = "https://github.com/ocaml/omd";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "omd";
  };
})
