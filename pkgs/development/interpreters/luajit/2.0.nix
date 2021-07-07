{ self, callPackage, lib }:
callPackage ./default.nix {
  inherit self;
  version = "2.0.5-2021-06-08";
  rev = "98f95f69180d48ce49289d6428b46a9ccdd67a46";
  isStable = true;
  sha256 = "1pdmhk5syp0nir80xcnkf6xy2w5rwslak8hgmjpgaxzlnrjcgs7p";
  extraMeta = { # this isn't precise but it at least stops the useless Hydra build
    platforms = with lib; filter (p: p != "aarch64-linux")
      (platforms.linux ++ platforms.darwin);
  };
}
