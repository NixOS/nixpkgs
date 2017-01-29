{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.10";
  branch = "2.8";
  sha256 = "1jd9vqrsng6swk1xsms3qvwqjzla58xbk3103qmnxkixa1rimkni";
})
