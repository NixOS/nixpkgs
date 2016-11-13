{ newScope, stdenv, isl, fetchsvn, overrideCC, wrapCC, darwin, ccWrapperFun }:
let
  callPackage = newScope (self // { inherit stdenv isl version fetch; });

  rev = "289607";
  version = "4.0.0";

  fetch = name: sha256: fetchsvn {
    url = "http://llvm.org/svn/llvm-project/${name}/trunk/";
    inherit rev sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "0ddjslcmkr64z8k1r7qz1hgrghgnipcsp5rbj30znpb1hqhyyq2k";
  clang-tools-extra_src = fetch "clang-tools-extra" "1y3qva7x4qbywzpi7bjaiq9bbwr2kdxkmn2xpzknkcqzi522vz0z";

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

    lldb = callPackage ./lldb.nix {};

    libcxx = callPackage ./libc++ {};

    libcxxabi = callPackage ./libc++abi.nix {};
  };
in self
