# Creating a package for a new llvm version and using this as a base? Great!
# Don't just copy and paste this and change version numbers, please.
# At least update the checksums,
# and change the version numbers in libcxx/darwin.patch.

{ pkgs, newScope, stdenv, isl, fetchurl, overrideCC, wrapCC }:
let
  callPackage = newScope (self // { inherit stdenv isl version fetch; });

  version = "3.8.0";

  fetch = fetch_v version;
  fetch_v = ver: name: sha256: fetchurl
  {
    url = "http://llvm.org/releases/${ver}/${name}-${ver}.src.tar.xz";
    inherit sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "c8d3387e55f229543dac1941769120f24dc50183150bf19d1b070d53d29d56b0";
  clang-tools-extra_src = fetch "clang-tools-extra" "afbda810106a6e64444bc164b921be928af46829117c95b996f2678ce4cb1ec4";

  self =
  {
    # we build llvm with compiler-rt support by default
    llvm = callPackage ./llvm.nix
    {
      inherit compiler-rt_src stdenv;
    };

    # we build clang with the extra tools as well
    clang = callPackage ./clang
    {
      inherit clang-tools-extra_src stdenv;
    };

    # lld doesn't build yet
    #lld = callPackage ./lld.nix { };

    #lldb = callPackage ./lldb.nix { };

    # libc++ and libc++abi aren't actually used for anything currently.
    # they're only really necessary on OS X, and even then only when testing compiler-rt
    # when building on OS X, libc++abi and libc++ cause lots of problems...
    # it would probably be wise to use these eventually, but for now let's
    # sweep them under the rug
    libcxx = callPackage ./libcxx { };

    libcxxabi = callPackage ./libcxxabi.nix { };
  };
in self
