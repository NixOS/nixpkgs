{ lowPrio, newScope, pkgs, stdenv, cmake, libstdcxxHook
, libxml2, python, isl, fetchurl, overrideCC, wrapCCWith
, buildLlvmTools # tools, but from the previous stage, for cross
, targetLlvmLibraries # libraries, but from the next stage, for cross
}:

let
  release_version = "5.0.2";
  version = release_version; # differentiating these is important for rc's

  fetch = name: sha256: fetchurl {
    url = "https://releases.llvm.org/${release_version}/${name}-${version}.src.tar.xz";
    inherit sha256;
  };

  clang-tools-extra_src = fetch "clang-tools-extra" "018b3fiwah8f8br5i26qmzh6sjvzchpn358sn8v079m49f2jldm3";

  tools = stdenv.lib.makeExtensible (tools: let
    callPackage = newScope (tools // { inherit stdenv cmake libxml2 python isl release_version version fetch; });
    mkExtraBuildCommands = cc: ''
      rsrc="$out/resource-root"
      mkdir "$rsrc"
      ln -s "${cc}/lib/clang/${release_version}/include" "$rsrc"
      ln -s "${targetLlvmLibraries.compiler-rt.out}/lib" "$rsrc/lib"
      echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
    '' + stdenv.lib.optionalString stdenv.targetPlatform.isLinux ''
      echo "--gcc-toolchain=${tools.clang-unwrapped.gcc}" >> $out/nix-support/cc-cflags
    '';
  in {

    llvm = callPackage ./llvm.nix { };

    clang-unwrapped = callPackage ./clang {
      inherit clang-tools-extra_src;
    };

    llvm-manpages = lowPrio (tools.llvm.override {
      enableManpages = true;
      python = pkgs.python;  # don't use python-boot
    });

    clang-manpages = lowPrio (tools.clang-unwrapped.override {
      enableManpages = true;
      python = pkgs.python;  # don't use python-boot
    });

    libclang = tools.clang-unwrapped.lib;

    clang = if stdenv.cc.isGNU then tools.libstdcxxClang else tools.libcxxClang;

    libstdcxxClang = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      extraPackages = [
        libstdcxxHook
        targetLlvmLibraries.compiler-rt
      ];
      extraBuildCommands = mkExtraBuildCommands cc;
    };

    libcxxClang = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      extraPackages = [
        targetLlvmLibraries.libcxx
        targetLlvmLibraries.libcxxabi
        targetLlvmLibraries.compiler-rt
      ];
      extraBuildCommands = mkExtraBuildCommands cc;
    };

    lld = callPackage ./lld.nix {};

    lldb = callPackage ./lldb.nix {};
  });

  libraries = stdenv.lib.makeExtensible (libraries: let
    callPackage = newScope (libraries // buildLlvmTools // { inherit stdenv cmake libxml2 python isl release_version version fetch; });
  in {

    compiler-rt = callPackage ./compiler-rt.nix {};

    stdenv = overrideCC stdenv buildLlvmTools.clang;

    libcxxStdenv = overrideCC stdenv buildLlvmTools.libcxxClang;

    libcxx = callPackage ./libc++ {};

    libcxxabi = callPackage ./libc++abi.nix {};

    openmp = callPackage ./openmp.nix {};
  });

in { inherit tools libraries; } // libraries // tools
