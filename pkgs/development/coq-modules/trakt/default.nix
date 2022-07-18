{ lib, mkCoqDerivation, coq, coq-elpi, version ? null }:
with lib;

mkCoqDerivation {
  pname = "trakt";
  owner = "ecranceMERCE";

  release."1.0".rev    = "d1c9daba8fe0584b526047862dd27ddf836dbbf2";
  release."1.0".sha256 = "sha256-Qhw5fWFYxUFO2kIWWz/og+4fuy9aYG27szfNk3IglhY=";

  inherit version;
  defaultVersion = with versions; switch [ coq.version ] [
    { cases = [ (range "8.13" "8.15") ]; out = "1.0"; }
  ] null;

  propagatedBuildInputs = [ coq-elpi ];

  meta = {
    description = "A generic goal preprocessing tool for proof automation tactics in Coq";
    maintainers = with maintainers; [ siraben ];
    license = licenses.cecill-b;
    platforms = platforms.unix;
  };
}
