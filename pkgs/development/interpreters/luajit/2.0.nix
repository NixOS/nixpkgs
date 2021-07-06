{ self, callPackage, lib }:
callPackage ./default.nix {
  inherit self;
  version = "2.0.5-2021-05-29";
  rev = "c2cfa04231785116d9d198462830f41ef94147c0";
  isStable = true;
  sha256 = "1fw64pv0dvzb9bgr2zwcv9q8gqgsmfnvrcrmrdfgj4ncamgdnilj";
  extraMeta = { # this isn't precise but it at least stops the useless Hydra build
    platforms = with lib; filter (p: p != "aarch64-linux")
      (platforms.linux ++ platforms.darwin);
  };
}
