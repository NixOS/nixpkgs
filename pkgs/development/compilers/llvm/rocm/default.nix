{ stdenv, fetchFromGitHub, callPackage, wrapCCWith }:

let
  version = "3.5.1";
  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "llvm-project";
    rev = "rocm-${version}";
    sha256 = "03k2xp8wf4awf1zcjc2hb3kf9bqp567c3s569gp1q3q1zjg6r2ib";
  };
in rec {
  clang = wrapCCWith rec {
    cc = clang-unwrapped;
    extraBuildCommands = ''
      rsrc="$out/resource-root"
      mkdir "$rsrc"
      ln -s "${cc}/lib/clang/11.0.0/include" "$rsrc"
      echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
      echo "--gcc-toolchain=${stdenv.cc.cc}" >> $out/nix-support/cc-cflags
      echo "-Wno-unused-command-line-argument" >> $out/nix-support/cc-cflags
      rm $out/nix-support/add-hardening.sh
      touch $out/nix-support/add-hardening.sh
    '';
  };

  clang-unwrapped = callPackage ./clang.nix {
    inherit lld llvm version;
    src = "${src}/clang";
  };

  lld = callPackage ./lld.nix {
    inherit llvm version;
    src = "${src}/lld";
  };

  llvm = callPackage ./llvm.nix {
    inherit version;
    src = "${src}/llvm";
  };
}
