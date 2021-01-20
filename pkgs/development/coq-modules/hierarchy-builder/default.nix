{ lib, mkCoqDerivation, which, coq, coq-elpi, version ? null }:

with lib; mkCoqDerivation {
  pname = "hierarchy-builder";
  owner = "math-comp";
  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = isGe "8.12";         out = "1.0.0"; }
    { case = range "8.11" "8.12"; out = "0.10.0"; }
  ] null;
  release."1.0.0".sha256  = "0yykygs0z6fby6vkiaiv3azy1i9yx4rqg8xdlgkwnf2284hffzpp";
  release."0.10.0".sha256 = "1a3vry9nzavrlrdlq3cys3f8kpq3bz447q8c4c7lh2qal61wb32h";
  releaseRev = v: "v${v}";

  propagatedBuildInputs = [ coq-elpi ];

  extraInstallFlags = [ "VFILES=structures.v" ];

  meta = {
    description = "Coq plugin embedding ELPI.";
    maintainers = [ maintainers.cohencyril ];
    license = licenses.lgpl21;
  };
}
