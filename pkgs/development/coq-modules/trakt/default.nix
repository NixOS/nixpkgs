{ lib, mkCoqDerivation, coq, coq-elpi, version ? null }:

mkCoqDerivation {
  pname = "trakt";
  owner = "ecranceMERCE";

<<<<<<< HEAD
  release."1.0".sha256 = "sha256-Qhw5fWFYxUFO2kIWWz/og+4fuy9aYG27szfNk3IglhY=";
  release."1.1".sha256 = "sha256-JmrtM9WcT8Bfy0WZCw8xdubuMomyXmfLXJwpnCNrvsg=";
  release."1.2".sha256 = "sha256-YQRtK2MjjsMlytdu9iutUDKhwOo4yWrSwhyBb2zNHoE=";
  release."1.2+8.13".sha256 = "sha256-hozms4sPSMr4lFkJ20x+uW9Wqt067bifnPQxdGyKhQQ=";

  inherit version;
  defaultVersion = with lib.versions; lib.switch [ coq.version ] [
    { cases = [ (range "8.15" "8.18") ]; out = "1.2"; }
    { cases = [ (isEq "8.13") ]; out = "1.2+8.13"; }
    { cases = [ (range "8.13" "8.17") ]; out = "1.1"; }
=======
  release."1.0".rev    = "d1c9daba8fe0584b526047862dd27ddf836dbbf2";
  release."1.0".sha256 = "sha256-Qhw5fWFYxUFO2kIWWz/og+4fuy9aYG27szfNk3IglhY=";

  inherit version;
  defaultVersion = with lib.versions; lib.switch [ coq.version ] [
    { cases = [ (range "8.13" "8.17") ]; out = "1.0"; }
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] null;

  propagatedBuildInputs = [ coq-elpi ];

  meta = with lib; {
    description = "A generic goal preprocessing tool for proof automation tactics in Coq";
    maintainers = with maintainers; [ siraben ];
<<<<<<< HEAD
    license = licenses.lgpl3Plus;
=======
    license = licenses.cecill-b;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.unix;
  };
}
