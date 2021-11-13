{ lib, buildNimPackage, fetchFromGitHub, SDL2 }:

buildNimPackage rec {
  pname = "c2nim";
  version = "0.9.18";
  nimBinOnly = true;
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = pname;
    rev = version;
    hash = "sha256-127ux36mfC+PnS2HIQffw+z0TSvzdQXnKRxqYV3XahU=";
  };
  meta = with lib;
    src.meta // {
      description = "Tool to translate Ansi C code to Nim";
      license = licenses.mit;
      maintainers = [ maintainers.ehmry ];
    };
}
