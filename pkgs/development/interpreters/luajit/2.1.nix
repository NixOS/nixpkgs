{ self, callPackage, passthruFun }:
callPackage ./default.nix {
  sourceVersion = { major = "2"; minor = "1"; patch = "0"; };
  inherit self passthruFun;
  version = "2.1.0-2022-10-04";
  rev = "6c4826f12c4d33b8b978004bc681eb1eef2be977";
  isStable = false;
  hash = "sha256-GMgoSVHrfIuLdk8mW9XgdemNFsAkkQR4wiGGjaAXAKg=";
}
