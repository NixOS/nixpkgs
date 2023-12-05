{ lib, mkCoqDerivation, coq, version ? null }:

mkCoqDerivation {
  pname = "pocklington";
  owner = "coq-community";

  release."8.12.0".rev    = "v8.12.0";
  release."8.12.0".sha256 = "sha256-0xBrw9+4g14niYdNqp0nx00fPJoSSnaDSDEaIVpPfjs=";

  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = isGe "8.7"; out = "8.12.0"; }
  ] null;

  meta = with lib; {
    description = "Pocklington's criterion for primality in Coq";
    maintainers = with maintainers; [ siraben ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
