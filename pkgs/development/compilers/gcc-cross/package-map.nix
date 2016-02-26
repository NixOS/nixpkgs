{ pkgs }:
let
  inherit (builtins) hasAttr singleton;
  inherit (pkgs) fetchurl;
  inherit (pkgs.lib) concatStringsSep fold getVersion splitString substring;
  mkAttr = name: ver: sha256: let
    origDer = if name == "gcc" then pkgs.gcc.cc
              else if name == "mpc" then pkgs.libmpc
              else if name == "isl" && substring 0 4 ver == "0.12" then pkgs.isl_0_12
              else pkgs."${name}";
    origUrls = if hasAttr "urls" origDer.src
                  then origDer.src.urls
                  else singleton origDer.src.url;
    origVer = getVersion origDer;
  in { "${name}"."${ver}" = fetchurl {
      urls = map (u: concatStringsSep ver (splitString origVer u)) origUrls;
      inherit sha256;
  };};
in
fold (v: a: a // v) {} [
  (mkAttr "binutils" "2.25"   "08r9i26b05zcwb9zxb6zllpfdiiicdfsgbpsjlrjmvx3rxjzrpi2")
  (mkAttr "gcc"      "4.9.2"  "1pbjp4blk2ycaa6r3jmw4ky5f1s9ji3klbqgv8zs2sl5jn1cj810")
  (mkAttr "cloog"    "0.18.1" "15j19gb078vmbpvwcx143h6cn98456jfvjw4zsa5z1qlvm70ll02")
  (mkAttr "gmp"      "6.0.0a" "1bwsfmf0vrx3rwl4xmi5jhhy3v1qx1xj0m7p9hb0fvcw9f09m3kz")
  (mkAttr "isl"      "0.12.2" "1d0zs64yw6fzs6b7kxq6nh9kvas16h8b43agwh30118jjzpdpczl")
  (mkAttr "linux"    "3.18.1" "13m0s2m0zg304w86yvcmxgbjl41c4kc420044avi8rnr1xwcscsq")
  (mkAttr "glibc"    "2.20"   "1g6ysvk15arpi7c1f1fpx5slgfr2k3dqd5xr0yvijajp1m0xxq9p")
  (mkAttr "mpc"      "1.0.2"  "1264h3ivldw5idph63x35dqqdzqqbxrm5vlir0xyx727i96zaqdm")
  (mkAttr "mpfr"     "3.1.2"  "0sqvpfkzamxdr87anzakf9dhkfh15lfmm5bsqajk02h1mxh3zivr")
]
