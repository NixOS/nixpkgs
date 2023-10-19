{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "npeg";
  version = "1.2.1";
  src = fetchFromGitHub {
    owner = "zevv";
    repo = pname;
    rev = version;
    hash = "sha256-kN91cp50ZL4INeRWqwrRK6CAkVXUq4rN4YlcN6WL/3Y=";
  };
  nimFlags = [ "--threads:off" ];
  meta = src.meta // {
    description = "NPeg is a pure Nim pattern matching library";
    maintainers = with lib.maintainers; [ ehmry ];
    license = lib.licenses.mit;
  };
}
