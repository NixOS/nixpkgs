{
  coq,
  mkCoqDerivation,
  stdenv,
  lib,
  VST,
  version ? null,
}:

mkCoqDerivation {
  pname = "Certigraph";
  owner = "Certigraph";

  inherit version;
  defaultVersion = with lib.versions;
    lib.switch [ coq.coq-version VST.version ] [
      { cases = [ "8.19" "2.14" ]; out = "live"; }
      { cases = [ (range "8.14" "8.16") (isGe "2.8") ]; out = "CPS-Coq8.16"; }
    ] null;
  release."live" = {
    rev = "a2db4cf823730a104ddbde7f170627a47fc2f1b7";
    sha256 = "sha256-653Prxa1iKV/feHRLU0qrbAk00IUOZ8c16jZ5Z+Xkq8=";
  };

  propagatedBuildInputs = [ VST ];

  makeFlags = lib.optional stdenv.is32bit [ "BITSIZE=32" ];

  meta = {
    description = "A library for verifying graph-manipulating programs";
    homepage = "https://github.com/Salamari/CertiGraph";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ definfo ];
  };
}
