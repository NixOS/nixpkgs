{ callPackage, fetchurl, coq }:

let param =

  let param_1_7 = {
    version = "1.7.0";
    sha256 = "05zgyi4wmasi1rcyn5jq42w0bi9713q9m8dl1fdgl66nmacixh39";
  }; in

  {
    "8.5" =  {
      version = "1.6.1";
      sha256 = "1j9ylggjzrxz1i2hdl2yhsvmvy5z6l4rprwx7604401080p5sgjw";
    };

    "8.6" = param_1_7;
    "8.7" = param_1_7;
    "8.8" = param_1_7;

  }."${coq.coq-version}"
; in

callPackage ./generic.nix {
  name = "coq${coq.coq-version}-ssreflect-${param.version}";
  src = fetchurl {
    url = "https://github.com/math-comp/math-comp/archive/mathcomp-${param.version}.tar.gz";
    inherit (param) sha256;
  };
}
