{ lib, fetchurl, buildDunePackage
, menhir, menhirLib
, fmt
, qcheck
}:

buildDunePackage rec {
  pname = "dolmen";
  version = "0.9";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/Gbury/dolmen/releases/download/v${version}/dolmen-${version}.tbz";
    hash = "sha256-AD21OFS6zDoz+lXtac95gXwQNppPfGvpRK8dzDZXigo=";
  };

  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [ menhirLib fmt ];

  doCheck = true;

  checkInputs = [ qcheck ];

  meta = {
    description = "An OCaml library providing clean and flexible parsers for input languages";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/Gbury/dolmen";
  };
}
