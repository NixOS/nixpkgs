{ lib, mkCoqDerivation, coq, version ? null
, equations
, mathcomp-ssreflect
, mathcomp-analysis
, extructures
, deriving
}:

(mkCoqDerivation {
  pname = "ssprove";
  owner = "SSProve";

  inherit version;
  defaultVersion = with lib.versions; lib.switch [coq.coq-version mathcomp-ssreflect.version] [
    { cases = [(range "8.18" "8.19") (range "2.1.0" "2.2.0")]; out = "0.2.0"; }
    # This is the original dependency:
    # { cases = ["8.17" "1.18.0"]; out = "0.1.0"; }
    # But it is not loadable. The math-comp nixpkgs configuration
    # will always only output version 1.18.0 for Coq 8.17.
    # Hence, the Coq 8.17 and math-comp 1.17.0 must be explicitly set
    # to load it.
    # (This version is not on the math-comp CI and hence not checked.)
    { cases = ["8.17" "1.17.0"]; out = "0.1.0"; }
  ] null;

  releaseRev = v: "v${v}";

  release."0.2.0".sha256 = "sha256-GDkWH0LUsW165vAUoYC5of9ndr0MbfBtmrPhsJVXi3o=";
  release."0.1.0".sha256 = "sha256-Yj+k+mBsudi3d6bRVlZLyM4UqQnzAX5tHvxtKoIuNTE=";

  propagatedBuildInputs = [equations
                           mathcomp-ssreflect
                           mathcomp-analysis
                           extructures
                           deriving];

  meta = with lib; {
    description = "SSProve: A Foundational Framework for Modular Cryptographic Proofs in Coq";
    license = licenses.mit;
    maintainers = [ {
      name = "Sebastian Ertel";
      email = "sebastian.ertel@gmail.com";
      github = "sertel";
      githubId = 3703100;
    } ];
  };

})
