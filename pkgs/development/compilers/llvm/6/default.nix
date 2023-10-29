{ lowPrio, newScope, pkgs, lib, stdenv, cmake, gccForLibs
, libxml2, python3, isl, fetchurl, overrideCC, wrapCCWith
, buildLlvmTools # tools, but from the previous stage, for cross
, targetLlvmLibraries # libraries, but from the next stage, for cross
, targetLlvm
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
    maintainers = lib.teams.llvm.members;

    # See llvm/cmake/config-ix.cmake.
    platforms   =
      lib.platforms.aarch64 ++
      lib.platforms.arm ++
      lib.platforms.mips ++
      lib.platforms.power ++
      lib.platforms.s390x ++
      lib.platforms.wasi ++
      lib.platforms.x86;
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
    # we need to reintroduce `outputSpecified` to get the expected behavior e.g. of lib.get*
    llvm = tools.libllvm;

    libllvm-polly = callPackage ./llvm {
      inherit llvm_meta;
      enablePolly = true;
    };

    llvm-polly = tools.libllvm-polly.lib // { outputSpecified = false; };

    libclang = callPackage ./clang {
      inherit clang-tools-extra_src llvm_meta;
    };

    clang-unwrapped = tools.libclang;

    llvm-manpages = lowPrio (tools.libllvm.override {
      enableManpages = true;
      enableSharedLibraries = false;
      python3 = pkgs.python3;  # don't use python-boot
    });

    clang-manpages = lowPrio (tools.libclang.override {
      enableManpages = true;
      python3 = pkgs.python3;  # don't use python-boot
    });

    # pick clang appropriate for package set we are targeting
    clang =
      /**/ if stdenv.targetPlatform.libc == null then tools.clangNoLibc
      # Treat Darwin’s top-level libc++ as the standard one for the platform. Otherwise, binaries
      # built with a non-default version of clang can end up linked against multiple versions of
      # libc++ simultaneously, which can lead to runtime crashes when both dylibs are loaded.
      # Note that the headers from the requested clang will be used, but the runtime library
      # will be the default version for Darwin. This is okay because libc++ defaults to building
      # with the stable API (LIBCXX_ABI_VERSION is 1).
      else if stdenv.targetPlatform.isDarwin then (
        let
          llvmLibcxxVersion = lib.getVersion llvmLibcxx;
          stdenvLibcxxVersion = lib.getVersion stdenvLibcxx;

          stdenvLibcxx = pkgs.stdenv.cc.libcxx;
          stdenvCxxabi = pkgs.stdenv.cc.libcxx.cxxabi;

          llvmLibcxx = tools.libcxxClang.libcxx;
          llvmCxxabi = tools.libcxxClang.libcxx.cxxabi;

          libcxx = pkgs.runCommand "${stdenvLibcxx.name}-${llvmLibcxxVersion}" {
            outputs = [ "out" "dev" ];
            inherit cxxabi;
            isLLVM = true;
          } ''
            mkdir -p "$dev/nix-support"
            ln -s '${stdenvLibcxx}' "$out"
            echo '${stdenvLibcxx}' > "$dev/nix-support/propagated-build-inputs"
            ln -s '${lib.getDev llvmLibcxx}/include' "$dev/include"
          '';

          cxxabi = pkgs.runCommand "${stdenvCxxabi.name}-${llvmLibcxxVersion}" {
            outputs = [ "out" "dev" ];
            inherit (stdenvCxxabi) libName;
          } ''
            mkdir -p "$dev/nix-support"
            ln -s '${stdenvCxxabi}' "$out"
            echo '${stdenvCxxabi}' > "$dev/nix-support/propagated-build-inputs"
            ln -s '${lib.getDev llvmCxxabi}/include' "$dev/include"
          '';
        in
        if llvmLibcxxVersion != stdenvLibcxxVersion
          then tools.libcxxClang.override {
            inherit libcxx;
            extraPackages = [ cxxabi targetLlvmLibraries.compiler-rt ];
          }
        else tools.libcxxClang
      )
      else if stdenv.targetPlatform.useLLVM or false then tools.clangUseLLVM
      else if (pkgs.targetPackages.stdenv or stdenv).cc.isGNU then tools.libstdcxxClang
      else tools.libcxxClang;

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
        libcxx.cxxabi
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
      inherit llvm_meta targetLlvm;
    };
  });
  noExtend = extensible: lib.attrsets.removeAttrs extensible [ "extend" ];

in { inherit tools libraries release_version; } // (noExtend libraries) // (noExtend tools)
