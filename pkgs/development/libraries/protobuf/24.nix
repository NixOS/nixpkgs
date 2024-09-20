{ callPackage, ... } @ args:

callPackage ./generic.nix ({
  version = "24.4";
  hash = "sha256-I+Xtq4GOs++f/RlVff9MZuolXrMLmrZ2z6mkBayqQ2s=";
} // args)
