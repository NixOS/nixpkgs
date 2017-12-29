{ callPackage, fetchurl, coq }:

let param =
  {
    "8.4" =  {
      version = "1.6.1";
      url = https://github.com/math-comp/math-comp/archive/mathcomp-1.6.1.tar.gz;
      sha256 = "1j9ylggjzrxz1i2hdl2yhsvmvy5z6l4rprwx7604401080p5sgjw";
    };

    "8.5" =  {
      version = "1.6.1";
      url = https://github.com/math-comp/math-comp/archive/mathcomp-1.6.1.tar.gz;
      sha256 = "1j9ylggjzrxz1i2hdl2yhsvmvy5z6l4rprwx7604401080p5sgjw";
    };

    "8.6" =  {
      version = "1.6.4";
      url = https://github.com/math-comp/math-comp/archive/mathcomp-1.6.4.tar.gz;
      sha256 = "0qmjjb6jsxmmf4gpw10r30rmrvwqgzirvvgyy41mz2vhgwis8wn6";
    };

    "8.7" = {
      version = "1.6.4";
      url = https://github.com/math-comp/math-comp/archive/mathcomp-1.6.4.tar.gz;
      sha256 = "0qmjjb6jsxmmf4gpw10r30rmrvwqgzirvvgyy41mz2vhgwis8wn6";
    };

  }."${coq.coq-version}"
; in

callPackage ./generic.nix {
  name = "coq${coq.coq-version}-ssreflect-${param.version}";
  src = fetchurl { inherit (param) url sha256; };
}
