{ lowPrio, newScope, pkgs, lib, stdenv, cmake, gccForLibs
, libxml2, python3, isl, fetchurl, overrideCC, wrapCCWith
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

  llvm_meta = {
    license     = lib.licenses.ncsa;
    maintainers = with lib.maintainers; [ lovek323 raskin dtzWill primeos ];
    platforms   = lib.platforms.all;
  };

  tools = lib.makeExtensible (tools: let
    callPackage = newScope (tools // { inherit stdenv cmake libxml2 python3 isl release_version version fetch buildLlvmTools; });
    mkExtraBuildCommands = cc: ''
      rsrc="$out/resource-root"
      mkdir "$rsrc"
      ln -s "${cc.lib}/lib/clang/${release_version}/include" "$rsrc"
      echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
      ln -s "${targetLlvmLibraries.compiler-rt.out}/lib" "$rsrc/lib"
    '';

  in {

    libllvm = callPackage ./llvm {
      inherit llvm_meta;
    };

    # `llvm` historically had the binaries.  When choosing an output explicitly,
    # we need to reintroduce `outputUnspecified` to get the expected behavior e.g. of lib.get*
    llvm = tools.libllvm.out // { outputUnspecified = true; };

    libllvm-polly = callPackage ./llvm {
      inherit llvm_meta;
      enablePolly = true;
    };

    llvm-polly = tools.libllvm-polly.lib // { outputUnspecified = true; };

    libclang = callPackage ./clang {
      inherit clang-tools-extra_src llvm_meta;
    };

    clang-unwrapped = tools.libclang.out // { outputUnspecified = true; };

    llvm-manpages = lowPrio (tools.libllvm.override {
      enableManpages = true;
      enableSharedLibraries = false;
      python3 = pkgs.python3;  # don't use python-boot
    });

    clang-manpages = lowPrio (tools.libclang.override {
      enableManpages = true;
      python3 = pkgs.python3;  # don't use python-boot
    });

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

    lld = callPackage ./lld {
      inherit llvm_meta;
    };

    lldb = callPackage ./lldb {
      inherit llvm_meta;
    };
  });

  libraries = lib.makeExtensible (libraries: let
    callPackage = newScope (libraries // buildLlvmTools // { inherit stdenv cmake libxml2 python3 isl release_version version fetch; });
  in {

    compiler-rt = callPackage ./compiler-rt {
      inherit llvm_meta;
    };

    stdenv = overrideCC stdenv buildLlvmTools.clang;

    libcxxStdenv = overrideCC stdenv buildLlvmTools.libcxxClang;

    libcxx = callPackage ./libcxx {
      inherit llvm_meta;
    };

    libcxxabi = callPackage ./libcxxabi {
      inherit llvm_meta;
    };

    openmp = callPackage ./openmp {
      inherit llvm_meta;
    };
  });

in { inherit tools libraries; } // libraries // tools
