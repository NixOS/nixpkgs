{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "vmath";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "treeform";
    repo = pname;
    rev = version;
    hash = "sha256-/v0lQIOMogTxFRtbssziW4W6VhMDepM6Si8igLgcx30=";
  };

  doCheck = true;

  meta = with lib;
    src.meta // {
      description = "Math vector library for graphical things";
      license = [ licenses.mit ];
      maintainers = [ maintainers.ehmry ];
    };
}
