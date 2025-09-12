{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
  equations,
  mathcomp-boot,
  mathcomp-analysis,
  mathcomp-experimental-reals,
  extructures,
  deriving,
  mathcomp-word,
}:

(mkCoqDerivation {
  pname = "ssprove";
  owner = "SSProve";

  inherit version;
  defaultVersion =
    let
      case = coq: mc: out: {
        cases = [
          coq
          mc
        ];
        inherit out;
      };
    in
    with lib.versions;
    lib.switch
      [ coq.coq-version mathcomp-boot.version ]
      [
        (case (range "8.18" "9.0") (range "2.3.0" "2.4.0") "0.2.4")
        (case (range "8.18" "8.20") (range "2.3.0" "2.3.0") "0.2.3")
        (case (range "8.18" "8.20") (range "2.1.0" "2.2.0") "0.2.2")
        # This is the original dependency:
        # (case "8.17" "1.18.0" "0.1.0")
        # But it is not loadable. The math-comp nixpkgs configuration
        # will always only output version 1.18.0 for Coq 8.17.
        # Hence, the Coq 8.17 and math-comp 1.17.0 must be explicitly set
        # to load it.
        # (This version is not on the math-comp CI and hence not checked.)
        (case "8.17" "1.17.0" "0.1.0")
      ]
      null;

  releaseRev = v: "v${v}";

  release."0.2.4".sha256 = "sha256-uglr47aDgSkKi2JyVyN+2BrokZISZUAE8OUylGjy7ds=";
  release."0.2.3".sha256 = "sha256-Y3dmNIF36IuIgrVILteofOv8e5awKfq93S4YN7enswI=";
  release."0.2.2".sha256 = "sha256-tBF8equJd6hKZojpe+v9h6Tg9xEnMTVFgOYK7ZnMfxk=";
  release."0.2.1".sha256 = "sha256-X00q5QFxdcGWeNqOV/PLTOqQyyfqFEinbGUTO7q8bC4=";
  release."0.2.0".sha256 = "sha256-GDkWH0LUsW165vAUoYC5of9ndr0MbfBtmrPhsJVXi3o=";
  release."0.1.0".sha256 = "sha256-Yj+k+mBsudi3d6bRVlZLyM4UqQnzAX5tHvxtKoIuNTE=";

  propagatedBuildInputs = [
    equations
    mathcomp-boot
    mathcomp-analysis
    mathcomp-experimental-reals
    extructures
    deriving
    mathcomp-word
  ];

  meta = with lib; {
    description = "SSProve: A Foundational Framework for Modular Cryptographic Proofs in Coq";
    license = licenses.mit;
    maintainers = [
      {
        name = "Sebastian Ertel";
        email = "sebastian.ertel@gmail.com";
        github = "sertel";
        githubId = 3703100;
      }
    ];
  };

})
