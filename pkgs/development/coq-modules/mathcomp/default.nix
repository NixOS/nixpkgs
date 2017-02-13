{ callPackage, fetchurl, coq }:

let param =
  {
    version = "1.6.1";
    url = https://github.com/math-comp/math-comp/archive/mathcomp-1.6.1.tar.gz;
    sha256 = "1j9ylggjzrxz1i2hdl2yhsvmvy5z6l4rprwx7604401080p5sgjw";
  }; in

callPackage ./generic.nix {
  name = "coq${coq.coq-version}-mathcomp-${param.version}";
  src = fetchurl { inherit (param) url sha256; };
}
