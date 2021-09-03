{ self, callPackage }:
callPackage ./default.nix rec {
  inherit self;
  owner = "openresty";
  repo = "luajit2";
  version = "2.1-20210510";
  rev = "v${version}";
  isStable = true;
  sha256 = "1h21w5axwka2j9jb86yc69qrprcavccyr2qihiw4b76r1zxzalvd";
}
