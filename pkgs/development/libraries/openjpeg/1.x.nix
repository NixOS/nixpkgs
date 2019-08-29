{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.5.2";
  branch = "1.5";
  revision = "version.1.5.2";
  sha256 = "1dvvpvb597i5z8srz2v4c5dsbxb966h125jx3m2z0r2gd2wvpfkp";
  testsSupport = false;
})
