{ pkgs, newScope, stdenv, isl, fetchurl }:
let
  callPackage = newScope (self // { inherit stdenv isl version fetch; });

  version = "3.6.0";

  fetch = fetch_v version;
  fetch_v = ver: name: sha256: fetchurl {
    url = "http://llvm.org/releases/${ver}/${name}-${ver}.src.tar.xz";
    inherit sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "04bbn946jninynkrjyp337xqs8ihn4fkz5xgvmywxkddwmwznjbz";
  clang-tools-extra_src = fetch "clang-tools-extra" "04n83gsmy2ghvn7vp9hamsgn332rx2g7sa4paskr0d4ihax4ka9s";

  self = {
    llvm = callPackage ./llvm.nix {
      inherit compiler-rt_src;
    };

    clang = callPackage ./clang.nix {
      inherit clang-tools-extra_src;
    };

    lldb = callPackage ./lldb.nix {};

    libcxx = callPackage ./libc++ { stdenv = pkgs.clangStdenv; };

    libcxxabi = callPackage ./libc++abi { stdenv = pkgs.clangStdenv; };
  };
in self
