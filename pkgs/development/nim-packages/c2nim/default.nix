{ lib, buildNimPackage, fetchFromGitHub, SDL2 }:

buildNimPackage rec {
  pname = "c2nim";
  version = "0.9.19";
  nimBinOnly = true;
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = pname;
    rev = version;
    hash = "sha256-E8sAhTFIWAnlfWyuvqK8h8g7Puf5ejLEqgLNb5N17os=";
  };
  meta = with lib;
    src.meta // {
      description = "Tool to translate Ansi C code to Nim";
      license = licenses.mit;
      maintainers = [ maintainers.ehmry ];
    };
}
