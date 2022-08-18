{ fetchurl
, callPackage
}:

callPackage ./common.nix {
  version = "4.1";

  src = fetchurl {
    url = "http://www.oasis-open.org/docbook/sgml/4.1/docbk41.zip";
    sha256 = "04b3gp4zkh9c5g9kvnywdkdfkcqx3kjc04j4mpkr4xk7lgqgrany";
  };
}
