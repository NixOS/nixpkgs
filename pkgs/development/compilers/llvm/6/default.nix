{ lowPrio, newScope, pkgs, lib, stdenv, cmake, gccForLibs
, libxml2, python3, isl, fetchurl, overrideCC, wrapCCWith
, buildPackages
, buildLlvmTools # tools, but from the previous stage, for cross
, targetLlvmLibraries # libraries, but from the next stage, for cross
}:

let
  release_version = "6.0.1";
  version = release_version; # differentiating these is important for rc's
  targetConfig = stdenv.targetPlatform.config;

  fetch = name: sha256: fetchurl {
    url = "https://releases.llvm.org/${release_version}/${name}-${version}.src.tar.xz";
    inherit sha256;
  };

  clang-tools-extra_src = fetch "clang-tools-extra" "1w8ml7fyn4vyxmy59n2qm4r1k1kgwgwkaldp6m45fdv4g0kkfbhd";

  tools = lib.makeExtensible (tools: let
    callPackage = newScope (tools // { inherit stdenv cmake libxml2 python3 isl release_version version fetch; });
    mkExtraBuildCommands = cc: ''
      rsrc="$out/resource-root"
      mkdir "$rsrc"
      ln -s "${cc}/lib/clang/${release_version}/include" "$rsrc"
      ln -s "${targetLlvmLibraries.compiler-rt.out}/lib" "$rsrc/lib"
      echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
    '';
  in {

    llvm = callPackage ./llvm { };

    clang-unwrapped = callPackage ./clang {
      inherit clang-tools-extra_src;
    };

    llvm-manpages = lowPrio (tools.llvm.override {
      enableManpages = true;
      enableSharedLibraries = false;
      python3 = pkgs.python3;  # don't use python-boot
    });

    clang-manpages = lowPrio (tools.clang-unwrapped.override {
      enableManpages = true;
      python3 = pkgs.python3;  # don't use python-boot
    });

    libclang = tools.clang-unwrapped.lib;

    clang = if stdenv.cc.isGNU then tools.libstdcxxClang else tools.libcxxClang;

    libstdcxxClang = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      # libstdcxx is taken from gcc in an ad-hoc way in cc-wrapper.
      libcxx = null;
      extraPackages = [
        targetLlvmLibraries.compiler-rt
      ];
      extraBuildCommands = mkExtraBuildCommands cc;
    };

    libcxxClang = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = targetLlvmLibraries.libcxx;
      extraPackages = [
        targetLlvmLibraries.libcxxabi
        targetLlvmLibraries.compiler-rt
      ];
      extraBuildCommands = mkExtraBuildCommands cc;
    };

    lld = callPackage ./lld {};

    lldb = callPackage ./lldb {};
  });

  libraries = lib.makeExtensible (libraries: let
    callPackage = newScope (libraries // buildLlvmTools // { inherit stdenv cmake libxml2 python3 isl release_version version fetch; });
  in {

    compiler-rt = callPackage ./compiler-rt {};

    stdenv = overrideCC stdenv buildLlvmTools.clang;

    libcxxStdenv = overrideCC stdenv buildLlvmTools.libcxxClang;

    libcxx = callPackage ./libc++ {};

    libcxxabi = callPackage ./libc++abi {};

    openmp = callPackage ./openmp.nix {};
  });

in { inherit tools libraries; } // libraries // tools
