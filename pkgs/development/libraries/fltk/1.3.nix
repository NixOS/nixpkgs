{ callPackage
, fetchurl
}:

callPackage ./generic.nix rec {
  version = "1.3.5";
  src = fetchurl {
    url = "https://www.fltk.org/pub/fltk/${version}/fltk-${version}-source.tar.gz";
    sha256 = "00jp24z1818k9n6nn6lx7qflqf2k13g4kxr0p8v1d37kanhb4ac7";
  };
}
