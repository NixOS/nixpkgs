{ stdenv, lib, buildPackages, fetchFromGitHub, callPackage, wrapCCWith, overrideCC }:

let
  version = "5.3.1";
  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "llvm-project";
    rev = "rocm-${version}";
    hash = "sha256-IKo7N8wWvh5PBrZ2mh1Vu5s3uUXhanqYtC4qLV/+JBs=";
  };
in rec {
  clang = wrapCCWith rec {
    cc = llvm;
    extraBuildCommands = ''
      clang_version=`${cc}/bin/clang -v 2>&1 | grep "clang version " | grep -E -o "[0-9.-]+"`
      rsrc="$out/resource-root"
      mkdir "$rsrc"
      ln -s "${cc}/lib/clang/$clang_version/include" "$rsrc"
      ln -s "${cc}/lib/clang/$clang_version/lib" "$rsrc/lib"
      echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
      echo "--gcc-toolchain=${stdenv.cc.cc}" >> $out/nix-support/cc-cflags
      rm $out/nix-support/add-hardening.sh
      touch $out/nix-support/add-hardening.sh
      # GPU compilation uses builtin lld
      substituteInPlace $out/bin/clang \
        --replace '-MM) dontLink=1 ;;' $'-MM | --cuda-device-only) dontLink=1 ;;\n--cuda-host-only | --cuda-compile-host-device) dontLink=0 ;;'
      substituteInPlace $out/bin/clang++ \
        --replace '-MM) dontLink=1 ;;' $'-MM | --cuda-device-only) dontLink=1 ;;\n--cuda-host-only | --cuda-compile-host-device) dontLink=0 ;;'
    '';
  };

  clangNoCompilerRt = wrapCCWith rec {
    cc = llvm;
    extraBuildCommands = ''
      clang_version=`${cc}/bin/clang -v 2>&1 | grep "clang version " | grep -E -o "[0-9.-]+"`
      rsrc="$out/resource-root"
      mkdir "$rsrc"
      ln -s "${cc}/lib/clang/$clang_version/include" "$rsrc"
      echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
      echo "--gcc-toolchain=${stdenv.cc.cc}" >> $out/nix-support/cc-cflags
      rm $out/nix-support/add-hardening.sh
      touch $out/nix-support/add-hardening.sh
      # GPU compilation uses builtin lld
      substituteInPlace $out/bin/clang \
        --replace '-MM) dontLink=1 ;;' $'-MM | --cuda-device-only) dontLink=1 ;;\n--cuda-host-only | --cuda-compile-host-device) dontLink=0 ;;'
      substituteInPlace $out/bin/clang++ \
        --replace '-MM) dontLink=1 ;;' $'-MM | --cuda-device-only) dontLink=1 ;;\n--cuda-host-only | --cuda-compile-host-device) dontLink=0 ;;'
    '';
  };

  llvm = callPackage ./llvm.nix {
    inherit src version;
  };
}
