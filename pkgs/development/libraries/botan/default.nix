{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.10";
  revision = "8";
  sha256 = "182f316rbdd6jrqn92vjms3jyb9syn4ic0nzi3b7rfjbj3zdabxw";
})
