{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "illwill";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "johnnovak";
    repo = "illwill";
    rev = "v${version}";
    hash = "sha256-4DHGVWzN/WTAyDRBBpXlcfKnYIcbFt42/iWInaBUwi4=";
  };

  meta = with lib;
    src.meta // {
      description = "A curses inspired simple cross-platform console library for Nim";
      license = [ licenses.wtfpl ];
      maintainers = with maintainers; [ sikmir ];
    };
}
