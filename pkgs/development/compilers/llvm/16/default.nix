{ lowPrio, newScope, pkgs, lib, stdenv, stdenvNoCC, cmake, ninja
, gccForLibs, preLibcCrossHeaders
, libxml2, python3, fetchFromGitHub, overrideCC, wrapCCWith, wrapBintoolsWith
, buildLlvmTools # tools, but from the previous stage, for cross
, targetLlvmLibraries # libraries, but from the next stage, for cross
, targetLlvm
# This is the default binutils, but with *this* version of LLD rather
# than the default LLVM verion's, if LLD is the choice. We use these for
# the `useLLVM` bootstrapping below.
, bootBintoolsNoLibc ?
    if stdenv.targetPlatform.linker == "lld"
    then null
    else pkgs.bintoolsNoLibc
, bootBintools ?
    if stdenv.targetPlatform.linker == "lld"
    then null
    else pkgs.bintools
, darwin
# LLVM release information; specify one of these but not both:
, gitRelease ? null
  # i.e.:
  # {
  #   version = /* i.e. "15.0.0" */;
  #   rev = /* commit SHA */;
  #   rev-version = /* human readable version; i.e. "unstable-2022-26-07" */;
  #   sha256 = /* checksum for this release, can omit if specifying your own `monorepoSrc` */;
  # }
, officialRelease ? { version = "16.0.6"; sha256 = "sha256-fspqSReX+VD+Nl/Cfq+tDcdPtnQPV1IRopNDfd5VtUs="; }
  # i.e.:
  # {
  #   version = /* i.e. "15.0.0" */;
  #   candidate = /* optional; if specified, should be: "rcN" */
  #   sha256 = /* checksum for this release, can omit if specifying your own `monorepoSrc` */;
  # }
# By default, we'll try to fetch a release from `github:llvm/llvm-project`
# corresponding to the `gitRelease` or `officialRelease` specified.
#
# You can provide your own LLVM source by specifying this arg but then it's up
# to you to make sure that the LLVM repo given matches the release configuration
# specified.
, monorepoSrc ? null
}:

assert let
  int = a: if a then 1 else 0;
  xor = a: b: ((builtins.bitXor (int a) (int b)) == 1);
in
  lib.assertMsg
    (xor
      (gitRelease != null)
      (officialRelease != null))
    ("must specify `gitRelease` or `officialRelease`" +
      (lib.optionalString (gitRelease != null) " — not both"));
let
  monorepoSrc' = monorepoSrc;
in let
  releaseInfo = if gitRelease != null then rec {
    original = gitRelease;
    release_version = original.version;
    version = gitRelease.rev-version;
  } else rec {
    original = officialRelease;
    release_version = original.version;
    version = if original ? candidate then
      "${release_version}-${original.candidate}"
    else
      release_version;
  };

  monorepoSrc = if monorepoSrc' != null then
    monorepoSrc'
  else let
    sha256 = releaseInfo.original.sha256;
    rev = if gitRelease != null then
      gitRelease.rev
    else
      "llvmorg-${releaseInfo.version}";
  in fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    inherit rev sha256;
  };

  inherit (releaseInfo) release_version version;

  llvm_meta = {
    license     = lib.licenses.ncsa;
    maintainers = lib.teams.llvm.members;

    # See llvm/cmake/config-ix.cmake.
    platforms   =
      lib.platforms.aarch64 ++
      lib.platforms.arm ++
      lib.platforms.m68k ++
      lib.platforms.mips ++
      lib.platforms.power ++
      lib.platforms.riscv ++
      lib.platforms.s390x ++
      lib.platforms.wasi ++
      lib.platforms.x86;
  };

  tools = lib.makeExtensible (tools: let
    callPackage = newScope (tools // { inherit stdenv cmake ninja libxml2 python3 release_version version monorepoSrc buildLlvmTools; });
    major = lib.versions.major release_version;
    mkExtraBuildCommands0 = cc: ''
      rsrc="$out/resource-root"
      mkdir "$rsrc"
      ln -s "${cc.lib}/lib/clang/${major}/include" "$rsrc"
      echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
    '';
    mkExtraBuildCommands = cc: mkExtraBuildCommands0 cc + ''
      ln -s "${targetLlvmLibraries.compiler-rt.out}/lib" "$rsrc/lib"
      ln -s "${targetLlvmLibraries.compiler-rt.out}/share" "$rsrc/share"
    '';

  bintoolsNoLibc' =
    if bootBintoolsNoLibc == null
    then tools.bintoolsNoLibc
    else bootBintoolsNoLibc;
  bintools' =
    if bootBintools == null
    then tools.bintools
    else bootBintools;

  in {

    libllvm = callPackage ./llvm {
      inherit llvm_meta;
    };

    # `llvm` historically had the binaries.  When choosing an output explicitly,
    # we need to reintroduce `outputSpecified` to get the expected behavior e.g. of lib.get*
    llvm = tools.libllvm;

    libclang = callPackage ./clang {
      inherit llvm_meta;
    };

    clang-unwrapped = tools.libclang;

    llvm-manpages = lowPrio (tools.libllvm.override {
      enableManpages = true;
      python3 = pkgs.python3;  # don't use python-boot
    });

    clang-manpages = lowPrio (tools.libclang.override {
      enableManpages = true;
      python3 = pkgs.python3;  # don't use python-boot
    });

    lldb-manpages = lowPrio (tools.lldb.override {
      enableManpages = true;
      python3 = pkgs.python3;  # don't use python-boot
    });

    # pick clang appropriate for package set we are targeting
    clang =
      /**/ if stdenv.targetPlatform.useLLVM or false then tools.clangUseLLVM
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

    lldb = callPackage ../common/lldb.nix {
      src = callPackage ({ runCommand }: runCommand "lldb-src-${version}" {} ''
        mkdir -p "$out"
        cp -r ${monorepoSrc}/cmake "$out"
        cp -r ${monorepoSrc}/lldb "$out"
      '') { };
      patches =
        let
          resourceDirPatch = callPackage
            ({ substituteAll, libclang }: substituteAll
              {
                src = ./lldb/resource-dir.patch;
                clangLibDir = "${libclang.lib}/lib";
              })
            { };
        in
        [
          # FIXME: do we need this? ./procfs.patch
          resourceDirPatch
          ./lldb/gnu-install-dirs.patch
        ]
        # This is a stopgap solution if/until the macOS SDK used for x86_64 is
        # updated.
        #
        # The older 10.12 SDK used on x86_64 as of this writing has a `mach/machine.h`
        # header that does not define `CPU_SUBTYPE_ARM64E` so we replace the one use
        # of this preprocessor symbol in `lldb` with its expansion.
        #
        # See here for some context:
        # https://github.com/NixOS/nixpkgs/pull/194634#issuecomment-1272129132
        ++ lib.optional (
          stdenv.targetPlatform.isDarwin
            && !stdenv.targetPlatform.isAarch64
            && (lib.versionOlder darwin.apple_sdk.sdk.version "11.0")
        ) ./lldb/cpu_subtype_arm64e_replacement.patch;
      inherit llvm_meta;
    };

    # Below, is the LLVM bootstrapping logic. It handles building a
    # fully LLVM toolchain from scratch. No GCC toolchain should be
    # pulled in. As a consequence, it is very quick to build different
    # targets provided by LLVM and we can also build for what GCC
    # doesn’t support like LLVM. Probably we should move to some other
    # file.

    bintools-unwrapped = callPackage ../common/bintools.nix { };

    bintoolsNoLibc = wrapBintoolsWith {
      bintools = tools.bintools-unwrapped;
      libc = preLibcCrossHeaders;
    };

    bintools = wrapBintoolsWith {
      bintools = tools.bintools-unwrapped;
    };

    clangUseLLVM = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = targetLlvmLibraries.libcxx;
      bintools = bintools';
      extraPackages = [
        libcxx.cxxabi
        targetLlvmLibraries.compiler-rt
      ] ++ lib.optionals (!stdenv.targetPlatform.isWasm) [
        targetLlvmLibraries.libunwind
      ];
      extraBuildCommands = mkExtraBuildCommands cc;
      nixSupport.cc-cflags =
        [ "-rtlib=compiler-rt"
          "-Wno-unused-command-line-argument"
          "-B${targetLlvmLibraries.compiler-rt}/lib"

          # Combat "__cxxabi_config.h not found". Maybe this could be fixed by
          # copying these headers into libcxx? Note that building libcxx
          # outside of monorepo isn't supported anymore, might be related to
          # https://github.com/llvm/llvm-project/issues/55632
          # ("16.0.3 libcxx, libcxxabi: circular build dependencies")
          # Looks like the machinery changed in https://reviews.llvm.org/D120727.
          "-I${lib.getDev targetLlvmLibraries.libcxx.cxxabi}/include/c++/v1"
        ]
        ++ lib.optional (!stdenv.targetPlatform.isWasm) "--unwindlib=libunwind"
        ++ lib.optional
          (!stdenv.targetPlatform.isWasm && stdenv.targetPlatform.useLLVM or false)
          "-lunwind"
        ++ lib.optional stdenv.targetPlatform.isWasm "-fno-exceptions";
    };

    clangNoLibcxx = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = null;
      bintools = bintools';
      extraPackages = [
        targetLlvmLibraries.compiler-rt
      ];
      extraBuildCommands = mkExtraBuildCommands cc;
      nixSupport.cc-cflags = [
        "-rtlib=compiler-rt"
        "-B${targetLlvmLibraries.compiler-rt}/lib"
        "-nostdlib++"
      ];
    };

    clangNoLibc = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = null;
      bintools = bintoolsNoLibc';
      extraPackages = [
        targetLlvmLibraries.compiler-rt
      ];
      extraBuildCommands = mkExtraBuildCommands cc;
      nixSupport.cc-cflags = [
        "-rtlib=compiler-rt"
        "-B${targetLlvmLibraries.compiler-rt}/lib"
      ];
    };

    clangNoCompilerRt = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = null;
      bintools = bintoolsNoLibc';
      extraPackages = [ ];
      extraBuildCommands = mkExtraBuildCommands0 cc;
      nixSupport.cc-cflags = [ "-nostartfiles" ];
    };

    clangNoCompilerRtWithLibc = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = null;
      bintools = bintools';
      extraPackages = [ ];
      extraBuildCommands = mkExtraBuildCommands0 cc;
    };

  });

  libraries = lib.makeExtensible (libraries: let
    callPackage = newScope (libraries // buildLlvmTools // { inherit stdenv cmake ninja libxml2 python3 release_version version monorepoSrc; });
  in {

    compiler-rt-libc = callPackage ./compiler-rt {
      inherit llvm_meta;
      stdenv = if stdenv.hostPlatform.useLLVM or false || (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isStatic)
               then overrideCC stdenv buildLlvmTools.clangNoCompilerRtWithLibc
               else stdenv;
    };

    compiler-rt-no-libc = callPackage ./compiler-rt {
      inherit llvm_meta;
      stdenv = if stdenv.hostPlatform.useLLVM or false
               then overrideCC stdenv buildLlvmTools.clangNoCompilerRt
               else stdenv;
    };

    # N.B. condition is safe because without useLLVM both are the same.
    compiler-rt = if stdenv.hostPlatform.isAndroid || stdenv.hostPlatform.isDarwin
      then libraries.compiler-rt-libc
      else libraries.compiler-rt-no-libc;

    stdenv = overrideCC stdenv buildLlvmTools.clang;

    libcxxStdenv = overrideCC stdenv buildLlvmTools.libcxxClang;

    libcxxabi = let
      # CMake will "require" a compiler capable of compiling C++ programs
      # cxx-header's build does not actually use one so it doesn't really matter
      # what stdenv we use here, as long as CMake is happy.
      cxx-headers = callPackage ./libcxx {
        inherit llvm_meta;
        # Note that if we use the regular stdenv here we'll get cycle errors
        # when attempting to use this compiler in the stdenv.
        #
        # The final stdenv pulls `cxx-headers` from the package set where
        # hostPlatform *is* the target platform which means that `stdenv` at
        # that point attempts to use this toolchain.
        #
        # So, we use `stdenv_` (the stdenv containing `clang` from this package
        # set, defined below) to sidestep this issue.
        #
        # Because we only use `cxx-headers` in `libcxxabi` (which depends on the
        # clang stdenv _anyways_), this is okay.
        stdenv = stdenv_;
        headersOnly = true;
      };

      # `libcxxabi` *doesn't* need a compiler with a working C++ stdlib but it
      # *does* need a relatively modern C++ compiler (see:
      # https://releases.llvm.org/15.0.0/projects/libcxx/docs/index.html#platform-and-compiler-support).
      #
      # So, we use the clang from this LLVM package set, like libc++
      # "boostrapping builds" do:
      # https://releases.llvm.org/15.0.0/projects/libcxx/docs/BuildingLibcxx.html#bootstrapping-build
      #
      # We cannot use `clangNoLibcxx` because that contains `compiler-rt` which,
      # on macOS, depends on `libcxxabi`, thus forming a cycle.
      stdenv_ = overrideCC stdenv buildLlvmTools.clangNoCompilerRtWithLibc;
    in callPackage ./libcxxabi {
      stdenv = stdenv_;
      inherit llvm_meta cxx-headers;
    };

    # Like `libcxxabi` above, `libcxx` requires a fairly modern C++ compiler,
    # so: we use the clang from this LLVM package set instead of the regular
    # stdenv's compiler.
    libcxx = callPackage ./libcxx {
      inherit llvm_meta;
      stdenv = overrideCC stdenv buildLlvmTools.clangNoLibcxx;
    };

    libunwind = callPackage ./libunwind {
      inherit llvm_meta;
      stdenv = overrideCC stdenv buildLlvmTools.clangNoLibcxx;
    };

    openmp = callPackage ./openmp {
      inherit llvm_meta targetLlvm;
    };
  });
  noExtend = extensible: lib.attrsets.removeAttrs extensible [ "extend" ];

in { inherit tools libraries release_version; } // (noExtend libraries) // (noExtend tools)
