{ newScope, stdenv, isl, fetchurl, overrideCC, wrapCC, darwin, ccWrapperFun }:
let
  callPackage = newScope (self // { inherit stdenv isl version fetch; });

  version = "4.0.0";
  rc = "rc2";

  fetch = fetch_v version;
  fetch_v = ver: name: sha256: fetchurl {
    url = "http://llvm.org/pre-releases/${version}/${rc}/${name}-${version}${rc}.src.tar.xz";
    # Once 4.0 is released, use this instead:
    # url = "http://llvm.org/releases/${version}/${name}-${ver}.src.tar.xz";
    inherit sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "07i098rj41h1sq2f30d6161924zr5yd9gx5kans79p7akxxgc0jr";
  clang-tools-extra_src = fetch "clang-tools-extra" "0ypvkv55pw88iaixib29sgz44d4pfs166vpswnrrbkqlhz92ns0z";

  self = {
    llvm = callPackage ./llvm.nix {
      inherit compiler-rt_src stdenv;
    };

    clang-unwrapped = callPackage ./clang {
      inherit clang-tools-extra_src stdenv;
    };

    clang = wrapCC self.clang-unwrapped;

    libcxxClang = ccWrapperFun {
      cc = self.clang-unwrapped;
      isClang = true;
      inherit (self) stdenv;
      /* FIXME is this right? */
      inherit (stdenv.cc) libc nativeTools nativeLibc;
      extraPackages = [ self.libcxx self.libcxxabi ];
    };

    stdenv = overrideCC stdenv self.clang;

    libcxxStdenv = overrideCC stdenv self.libcxxClang;

    lld = callPackage ./lld.nix {};

    lldb = callPackage ./lldb.nix {};

    libcxx = callPackage ./libc++ {};

    libcxxabi = callPackage ./libc++abi.nix {};
  };
in self
