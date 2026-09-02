{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "25.9";
    hash = "sha256-Psv9dJxrHnlWTLZF+FwjqB/Yw2r8DWdcuvzB9vv0Nok=";
  }
  // args
)
