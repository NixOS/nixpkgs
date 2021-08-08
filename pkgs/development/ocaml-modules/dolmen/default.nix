{ lib, fetchurl, buildDunePackage
, menhir, menhirLib
, fmt
}:

buildDunePackage rec {
  pname = "dolmen";
  version = "0.6";

  useDune2 = true;

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/Gbury/dolmen/releases/download/v${version}/dolmen-v${version}.tbz";
    sha256 = "133l23mwxa9xy340izvk4zp5jqjz2cwsm2innsgs2kg85pd39c41";
  };

  buildInputs = [ menhir ];
  propagatedBuildInputs = [ menhirLib fmt ];

  doCheck = true;

  meta = {
    description = "An OCaml library providing clean and flexible parsers for input languages";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/Gbury/dolmen";
  };
}
