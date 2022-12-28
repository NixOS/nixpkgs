{ lib
, buildDunePackage
, fetchurl
, ocaml

, alcotest
, eqaf
, fmt
}:

buildDunePackage rec {
  pname = "callipyge";
  version = "0.2";

  src = fetchurl {
    url = "https://github.com/oklm-wsh/Callipyge/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "sha256-T/94a88xvK51TggjXecdKc9kyTE9aIyueIt5T24sZB0=";
  };

  useDune2 = true;

  minimumOCamlVersion = "4.03";

  propagatedBuildInputs = [ fmt eqaf ];

  # alcotest isn't available for OCaml < 4.08 due to fmt
  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ alcotest ];

  meta = {
    homepage = "https://github.com/oklm-wsh/Callipyge";
    description = "Curve25519 in OCaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fufexan ];
  };
}
