import ./generic.nix rec {
  major_version = "4";
  minor_version = "01";
  patch_version = "0";
  patches = [ ./fix-clang-build-on-osx.diff ];
  sha256 = "03d7ida94s1gpr3gadf4jyhmh5rrszd5s4m4z59daaib25rvfyv7";
}
