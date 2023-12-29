{ lib, callPackage, mkCoqDerivation, coq, coq-ext-lib, version ? null }:

(mkCoqDerivation {
  pname = "simple-io";
  owner = "Lysxia";
  repo = "coq-simple-io";
  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = range "8.11" "8.18"; out = "1.8.0"; }
    { case = range "8.7"  "8.13"; out = "1.3.0"; }
  ] null;
  release."1.8.0".sha256 = "sha256-3ADNeXrBIpYRlfUW+LkLHUWV1w1HFrVc/TZISMuwvRY=";
  release."1.7.0".sha256 = "sha256:1a1q9x2abx71hqvjdai3n12jxzd49mhf3nqqh3ya2ssl2lj609ci";
  release."1.3.0".sha256 = "1yp7ca36jyl9kz35ghxig45x6cd0bny2bpmy058359p94wc617ax";
  mlPlugin = true;
  nativeBuildInputs = [ coq.ocamlPackages.cppo ];
  propagatedBuildInputs = [ coq-ext-lib ]
  ++ (with coq.ocamlPackages; [ ocaml findlib ocamlbuild ]);

  doCheck = true;
  checkTarget = "test";

  passthru.tests.HelloWorld = callPackage ./test.nix {};

  meta = with lib; {
    description = "Purely functional IO for Coq";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}).overrideAttrs (o: lib.optionalAttrs (lib.versionAtLeast o.version "1.8.0" || o.version == "dev") {
  doCheck = false;
  useDune = true;
})
