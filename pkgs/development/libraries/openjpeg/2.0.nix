{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2.0.1";
  branch = "2";
  revision = "version.2.0.1";
  sha256 = "03d0r8x66cxri9i20nr9gm1jnkp85yyd8mkrbmawv5nvybd0r7wv";
})
