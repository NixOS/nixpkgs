{ lib
, buildDunePackage
, fetchurl
, alcotest
, eqaf
, fmt
}:

buildDunePackage rec {
  pname = "callipyge";
  version = "0.2";

  src = fetchurl {
    url = "https://github.com/oklm-wsh/Callipyge/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-T/94a88xvK51TggjXecdKc9kyTE9aIyueIt5T24sZB0=";
  };

  duneVersion = "3";

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [ fmt eqaf ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    homepage = "https://github.com/oklm-wsh/Callipyge";
    description = "Curve25519 in OCaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fufexan ];
  };
}
