{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "hg";
  rev = "5f9f7194267b76f733e9ffb0f9e8b474dfe89a71";
  sha256 = "056ng8nsadmjf6s7igbgbxmiapjcxpfy6pbayl764xbhpkv4md88";
})