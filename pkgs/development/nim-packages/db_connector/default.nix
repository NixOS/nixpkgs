{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage (final: prev: {
  pname = "db_connector";
  version = "unstable-2023-02-23";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "db_connector";
    rev = "e65693709dd042bc723c8f1d46cc528701f1c479";
    hash = "sha256-g5X51VbES8OxR5m9WexK70Yo6S2PnroKLabj1cUu1P0=";
  };
  doCheck = false; # tests only worked in the Nim sources
  meta = final.src.meta // {
    description = "Unified db connector in Nim";
    homepage = "https://github.com/nim-lang/db_connector";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ ehmry ];
  };
})
