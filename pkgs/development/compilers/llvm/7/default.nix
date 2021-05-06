{ lowPrio, newScope, pkgs, lib, stdenv, cmake, gccForLibs
, libxml2, python3, isl, fetchurl, overrideCC, wrapCCWith, wrapCCWithoutLibc, wrapBintoolsWith
, buildLlvmTools # tools, but from the previous stage, for cross
, targetLlvmLibraries # libraries, but from the next stage, for cross
}:

let
  release_version = "7.1.0";
  version = release_version; # differentiating these is important for rc's
  targetConfig = stdenv.targetPlatform.config;

  fetch = name: sha256: fetchurl {
    url = "https://releases.llvm.org/${release_version}/${name}-${version}.src.tar.xz";
    inherit sha256;
  };

  clang-tools-extra_src = fetch "clang-tools-extra" "0lb4kdh7j2fhfz8kd6iv5df7m3pikiryk1vvwsf87spc90n09q0w";

  tools = lib.makeExtensible (tools: let
    callPackage = newScope (tools // { inherit stdenv cmake libxml2 python3 isl release_version version fetch buildLlvmTools; });
    mkExtraBuildCommands = cc: ''
      rsrc="$out/resource-root"
      mkdir "$rsrc"
      ln -s "${cc.lib}/lib/clang/${release_version}/include" "$rsrc"
      ln -s "${targetLlvmLibraries.compiler-rt.out}/lib" "$rsrc/lib"
      echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
    '';

  in {

    libllvm = callPackage ./llvm { };

    # `llvm` historically had the binaries. But this migration
    # technique also impedes `lib.get*`. Perhaps we will revisit it.
    llvm = tools.libllvm.out;

    libllvm-polly = callPackage ./llvm { enablePolly = true; };

    llvm-polly = tools.libllvm-polly.lib;

    libclang = callPackage ./clang {
      inherit clang-tools-extra_src;
    };

    clang-unwrapped = tools.libclang.out;

    clang-polly-unwrapped = callPackage ./clang {
      inherit clang-tools-extra_src;
      libllvm = tools.libllvm-polly;
      enablePolly = true;
    };

    llvm-manpages = lowPrio (tools.libllvm.override {
      enableManpages = true;
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

    clangNoLibcxx = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = null;
      bintools = wrapBintoolsWith {
        inherit (tools) bintools;
      };
      extraPackages = [
        targetLlvmLibraries.compiler-rt
      ];
      extraBuildCommands = ''
        echo "-rtlib=compiler-rt" >> $out/nix-support/cc-cflags
        echo "-B${targetLlvmLibraries.compiler-rt}/lib" >> $out/nix-support/cc-cflags
        echo "-nostdlib++" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommands cc;
    };

    clangNoLibcYesCompilerRt = wrapCCWithoutLibc rec {
      cc = tools.clang-unwrapped;
      extraPackages = [
        targetLlvmLibraries.compiler-rt
      ];
      extraBuildCommands = ''
        echo "-rtlib=compiler-rt" >> $out/nix-support/cc-cflags
        echo "-B${targetLlvmLibraries.compiler-rt}/lib" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommands cc;
    };

    # Darwin "builds" Libsystem then compiler-rt
    clangYesLibcNoCompilerRt = wrapCCWith {
      cc = tools.clang-unwrapped;
      libcxx = null;
      extraPackages = [ ];
      extraBuildCommands = ''
        echo "-nostartfiles" >> $out/nix-support/cc-cflags
      '';
    };

    clangNoLibcNoCompilerRt = wrapCCWithoutLibc {
      cc = tools.clang-unwrapped;
      libcxx = null;
      extraPackages = [ ];
      extraBuildCommands = ''
        echo "-nostartfiles" >> $out/nix-support/cc-cflags
      '';
    };

    lld = callPackage ./lld {};

    lldb = callPackage ./lldb {};

    # Below, is the LLVM bootstrapping logic. It handles building a
    # fully LLVM toolchain from scratch. No GCC toolchain should be
    # pulled in. As a consequence, it is very quick to build different
    # targets provided by LLVM and we can also build for what GCC
    # doesn’t support like LLVM. Probably we should move to some other
    # file.

    bintools = callPackage ./bintools.nix {};

    lldClang = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = targetLlvmLibraries.libcxx;
      bintools = wrapBintoolsWith {
        inherit (tools) bintools;
      };
      extraPackages = [
        targetLlvmLibraries.libcxxabi
        targetLlvmLibraries.compiler-rt
      ];
      extraBuildCommands = ''
        echo "-rtlib=compiler-rt -Wno-unused-command-line-argument" >> $out/nix-support/cc-cflags
        echo "-B${targetLlvmLibraries.compiler-rt}/lib" >> $out/nix-support/cc-cflags
      '' + lib.optionalString (!stdenv.targetPlatform.isWasm) ''
        echo "--unwindlib=libunwind" >> $out/nix-support/cc-cflags
      '' + lib.optionalString stdenv.targetPlatform.isWasm ''
        echo "-fno-exceptions" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommands cc;
    };

    lldClangNoLibcxx = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = null;
      bintools = wrapBintoolsWith {
        inherit (tools) bintools;
      };
      extraPackages = [
        targetLlvmLibraries.compiler-rt
      ];
      extraBuildCommands = ''
        echo "-rtlib=compiler-rt" >> $out/nix-support/cc-cflags
        echo "-B${targetLlvmLibraries.compiler-rt}/lib" >> $out/nix-support/cc-cflags
        echo "-nostdlib++" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommands cc;
    };

    lldClangNoLibc = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = null;
      bintools = wrapBintoolsWith {
        inherit (tools) bintools;
        libc = null;
      };
      extraPackages = [
        targetLlvmLibraries.compiler-rt
      ];
      extraBuildCommands = ''
        echo "-rtlib=compiler-rt" >> $out/nix-support/cc-cflags
        echo "-B${targetLlvmLibraries.compiler-rt}/lib" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommands cc;
    };

    lldClangNoCompilerRt = wrapCCWith {
      cc = tools.clang-unwrapped;
      libcxx = null;
      bintools = wrapBintoolsWith {
        inherit (tools) bintools;
        libc = null;
      };
      extraPackages = [ ];
      extraBuildCommands = ''
        echo "-nostartfiles" >> $out/nix-support/cc-cflags
      '';
    };

  });

  libraries = lib.makeExtensible (libraries: let
    callPackage = newScope (libraries // buildLlvmTools // { inherit stdenv cmake libxml2 python3 isl release_version version fetch; });
  in {

    compiler-rt = callPackage ./compiler-rt {
      stdenv =
        /**/ if stdenv.hostPlatform.useLLVM or false
          then overrideCC stdenv buildLlvmTools.lldClangNoCompilerRt
        else if stdenv.hostPlatform != stdenv.buildPlatform && stdenv.hostPlatform.isDarwin
          then overrideCC stdenv buildLlvmTools.clangYesLibcNoCompilerRt
        else stdenv;
    };

    stdenv = overrideCC stdenv buildLlvmTools.clang;

    libcxxStdenv = overrideCC stdenv buildLlvmTools.libcxxClang;

    libcxx = callPackage ./libc++ ({} //
      (lib.optionalAttrs (stdenv.hostPlatform != stdenv.buildPlatform && stdenv.hostPlatform.isDarwin) {
        stdenv = overrideCC stdenv buildLlvmTools.clangNoLibcxx;
      }) //
      (lib.optionalAttrs (stdenv.hostPlatform.useLLVM or false) {
        stdenv = overrideCC stdenv buildLlvmTools.lldClangNoLibcxx;
      }));

    libcxxabi = callPackage ./libc++abi ({} //
      (lib.optionalAttrs (stdenv.hostPlatform != stdenv.buildPlatform && stdenv.hostPlatform.isDarwin) {
        stdenv = overrideCC stdenv buildLlvmTools.clangYesLibcNoCompilerRt;
      }) //
      (lib.optionalAttrs (stdenv.hostPlatform.useLLVM or false) {
        stdenv = overrideCC stdenv buildLlvmTools.lldClangNoLibcxx;
        libunwind = libraries.libunwind;
      }));

    libunwind = callPackage ./libunwind ({
      inherit (buildLlvmTools) llvm;
    } // lib.optionalAttrs (stdenv.hostPlatform.useLLVM or false) {
      stdenv = overrideCC stdenv buildLlvmTools.lldClangNoLibcxx;
    });

    openmp = callPackage ./openmp.nix {};
  });

in { inherit tools libraries; } // libraries // tools
