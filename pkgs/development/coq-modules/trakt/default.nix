{ lib, mkCoqDerivation, coq, coq-elpi, version ? null }:

mkCoqDerivation {
  pname = "trakt";
  owner = "ecranceMERCE";

  release."1.0".sha256 = "sha256-Qhw5fWFYxUFO2kIWWz/og+4fuy9aYG27szfNk3IglhY=";
  release."1.1".sha256 = "sha256-JmrtM9WcT8Bfy0WZCw8xdubuMomyXmfLXJwpnCNrvsg=";
  release."1.2".sha256 = "sha256-YQRtK2MjjsMlytdu9iutUDKhwOo4yWrSwhyBb2zNHoE=";
  release."1.2+8.13".sha256 = "sha256-hozms4sPSMr4lFkJ20x+uW9Wqt067bifnPQxdGyKhQQ=";

  inherit version;
  defaultVersion = with lib.versions; lib.switch [ coq.version ] [
    { cases = [ (range "8.15" "8.17") ]; out = "1.2"; }
    { cases = [ (isEq "8.13") ]; out = "1.2+8.13"; }
    { cases = [ (range "8.13" "8.17") ]; out = "1.1"; }
  ] null;

  propagatedBuildInputs = [ coq-elpi ];

  meta = with lib; {
    description = "Generic goal preprocessing tool for proof automation tactics in Coq";
    maintainers = with maintainers; [ siraben ];
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
  };
}
