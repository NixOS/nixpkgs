{ lib, buildNimPackage, fetchFromGitHub, snappy }:

buildNimPackage rec {
  pname = "snappy";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "jangko";
    repo = pname;
    rev = "d13e2ccb2acaa4e8dedce4f25e8dbf28e19278a6";
    hash = "sha256-18CFRuDK+E701MHrCixx22QSVmglTc0EJwrMCsKwayM=";
  };
  propagatedBuildInputs = [ snappy ];
  doCheck = false;
  meta = with lib;
    src.meta // {
      description = "Nim implementation of snappy compression algorithm";
      license = [ lib.licenses.mit ];
      maintainers = [ maintainers.ehmry ];
    };
}
