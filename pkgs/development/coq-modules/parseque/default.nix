{
  lib,
  mkCoqDerivation,
  which,
  coq,
  stdlib,
  version ? null,
}:

with lib;
mkCoqDerivation {
  pname = "parseque";
  repo = "parseque";
  owner = "rocq-community";

  inherit version;
  defaultVersion =
    with versions;
    switch
      [ coq.coq-version ]
      [
        {
          cases = [ (range "8.16" "9.0") ];
          out = "0.2.2";
        }
      ]
      null;

  release."0.2.2".sha256 = "sha256-O50Rs7Yf1H4wgwb7ltRxW+7IF0b04zpfs+mR83rxT+E=";

  releaseRev = v: "v${v}";

  propagatedBuildInputs = [ stdlib ];

  meta = {
    description = "Total parser combinators in Coq/Rocq";
    maintainers = with maintainers; [ womeier ];
    license = licenses.mit;
  };
}
