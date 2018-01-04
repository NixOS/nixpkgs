args@{ callPackage, ... }:

callPackage (import ./generic.nix {
  version = "1.1.6";
  sha256 = "1xlh0sqypjbx0imw3bkbjwgwb4bm6zl7c0y01p0xsw8ncfmwjll7";
}) args
