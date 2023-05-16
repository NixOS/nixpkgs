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
<<<<<<< HEAD
  doCheck = false;
=======
  patches = [ ./config.patch ];
  preCheck = ''
    mkdir $NIX_BUILD_TOP/nimcache/
    mv -v tests/data $NIX_BUILD_TOP/nimcache/data
  ''; # test standards, please
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib;
    src.meta // {
      description = "Nim implementation of snappy compression algorithm";
      license = [ lib.licenses.mit ];
      maintainers = [ maintainers.ehmry ];
    };
}
