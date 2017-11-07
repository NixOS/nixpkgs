{ callPackage, fetchurl, coq }:

let param =
  {
    version = "1.6.2";
    url = https://github.com/math-comp/math-comp/archive/mathcomp-1.6.2.tar.gz;
    sha256 = "0lg5ncr7p4y8qqq6pfw6brqc6a9xzlfa0drprwfdn0rnyaq5nca6";
  }; in

callPackage ./generic.nix {
  name = "coq${coq.coq-version}-mathcomp-${param.version}";
  src = fetchurl { inherit (param) url sha256; };
}
