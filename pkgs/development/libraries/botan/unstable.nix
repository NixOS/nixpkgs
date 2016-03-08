{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.11";
  revision = "28";
  sha256 = "0cjr3zkara8js1fbm8ddcbd5mkizxh1wm6fja13psw5j8mpwj554";
  openssl = null;
})
