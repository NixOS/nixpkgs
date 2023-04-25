{ fetchpatch
, callPackage
}:

callPackage ./generic.nix {
  version = "4.0.0";
  hash = "sha256-cXDFqt2KgMFGfdh6NGE+JmP4R0Wm9LNHM0eIblYe6zU=";
  patches = [ ];
}
