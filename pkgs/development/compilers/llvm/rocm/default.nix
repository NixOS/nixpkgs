{ lib, fetchFromGitHub, callPackage, wrapCCWith }:

let
  version = "4.0.1";
  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "llvm-project";
    rev = "rocm-${version}";
    hash = "sha256-5mQ8tN7A045JCF7tHKgAZAbyVmXOd6Wf0CVUiPA80YM=";
  };
in rec {
  clang = wrapCCWith rec {
    cc = clang-unwrapped;
    extraBuildCommands = ''
      clang_version=`${cc}/bin/clang -v 2>&1 | grep "clang version " | grep -E -o "[0-9.-]+"`
      rsrc="$out/resource-root"
      mkdir "$rsrc"
      ln -s "${cc}/lib/clang/$clang_version/include" "$rsrc"
      echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
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
