{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.7";
  branch = "2.8";
  sha256 = "1rggcy8kflmlvdyf5yqv0zshycysyqz45fl06v8zsh2n6d5cwxw7";
})
