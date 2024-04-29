{ lib, mkCoqDerivation, coq, version ? null
, equations
, mathcomp
, mathcomp-analysis
, extructures
, deriving
}:

(mkCoqDerivation {
  pname = "ssprove";
  owner = "SSProve";

  inherit version;
  defaultVersion = with lib.versions; lib.switch [coq.coq-version mathcomp.version] [
    { cases = [(isEq "8.19") (isEq "2.2.0") ]; out = "0.2.0"; }
    { cases = [(isEq "8.18") (isEq "2.1.0") ]; out = "0.2.0"; }
    { cases = [(isEq "8.17") (isEq "1.17")]; out = "0.1.0"; }
  ] null;

  releaseRev = v: "v${v}";

  release."0.2.0".sha256 = "sha256-GDkWH0LUsW165vAUoYC5of9ndr0MbfBtmrPhsJVXi3o=";
  release."0.1.0".sha256 = "sha256-Yj+k+mBsudi3d6bRVlZLyM4UqQnzAX5tHvxtKoIuNTE=";

  propagatedBuildInputs = [equations
                           mathcomp
                           mathcomp-analysis
                           extructures
                           deriving];

  meta = with lib; {
    description = "SSProve: A Foundational Framework for Modular Cryptographic Proofs in Coq";
    license = licenses.mit;
    maintainers = [ "Theo Winterhalter" ];
  };

})
