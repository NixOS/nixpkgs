{ callPackage, fetchurl, coq }:

let param =
  {
    version = "1.6.4";
    url = https://github.com/math-comp/math-comp/archive/mathcomp-1.6.4.tar.gz;
    sha256 = "0qmjjb6jsxmmf4gpw10r30rmrvwqgzirvvgyy41mz2vhgwis8wn6";
  }; in

callPackage ./generic.nix {
  name = "coq${coq.coq-version}-mathcomp-${param.version}";
  src = fetchurl { inherit (param) url sha256; };
}
