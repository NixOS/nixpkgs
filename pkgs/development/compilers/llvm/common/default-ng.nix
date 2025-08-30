{
  lib,
  newScope,
  stdenv,
  darwin,
  overrideCC,
  lowPrio,
  fetchFromGitHub,
  gitRelease ? null,
  officialRelease ? null,
  monorepoSrc ? null,
  version ? null,
  patchesFn ? lib.id,
  wrapCCWith,
  wrapBintoolsWith,
  binutilsNoLibc,
  binutils,
  buildPackages,
  targetPackages,
  buildLlvmPackages,
  targetLlvmPackages,
  makeScopeWithSplicing',
  otherSplices,
  pkgs,
  libxcrypt,
  bootBintoolsNoLibc,
  bootBintools,
  ...
}@args:

assert lib.assertMsg (lib.xor (gitRelease != null) (officialRelease != null)) (
  "must specify `gitRelease` or `officialRelease`"
  + (lib.optionalString (gitRelease != null) " — not both")
);

let
  monorepoSrc' = monorepoSrc;

  metadata = rec {
    # Import releaseInfo separately to avoid infinite recursion
    inherit
      (import ./common-let.nix {
        inherit (args)
          lib
          gitRelease
          officialRelease
          version
          ;
      })
      releaseInfo
      ;
    inherit (releaseInfo) release_version version;
    inherit
      (import ./common-let.nix {
        inherit
          lib
          fetchFromGitHub
          release_version
          gitRelease
          officialRelease
          monorepoSrc'
          version
          ;
      })
      llvm_meta
      monorepoSrc
      ;
    src = monorepoSrc;
    versionDir =
      (builtins.toString ../.)
      + "/${if (gitRelease != null) then "git" else lib.versions.major release_version}";
    getVersionFile =
      p:
      builtins.path {
        name = builtins.baseNameOf p;
        path =
          let
            patches = args.patchesFn (import ./patches.nix);

            constraints = patches."${p}" or null;
            matchConstraint =
              {
                before ? null,
                after ? null,
                path,
              }:
              let
                check = fn: value: if value == null then true else fn release_version value;
                matchBefore = check lib.versionOlder before;
                matchAfter = check lib.versionAtLeast after;
              in
              matchBefore && matchAfter;

            patchDir =
              toString
                (
                  if constraints == null then
                    { path = metadata.versionDir; }
                  else
                    (lib.findFirst matchConstraint { path = metadata.versionDir; } constraints)
                ).path;
          in
          "${patchDir}/${p}";
      };
  };
in
makeScopeWithSplicing' {
  inherit otherSplices;
  f =
    llvmPackages:
    let
      callPackage = llvmPackages.newScope (
        args
        // metadata
        // {
          buildLlvmTools = buildLlvmPackages;
          targetLlvm = targetLlvmPackages.llvm;
        }
      );

      clangVersion =
        if (lib.versionOlder metadata.release_version "16") then
          metadata.release_version
        else
          lib.versions.major metadata.release_version;

      mkExtraBuildCommands0 =
        cc:
        ''
          rsrc="$out/resource-root"
          mkdir "$rsrc"
          echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
        ''
        # clang standard c headers are incompatible with FreeBSD so we have to put them in -idirafter instead of -resource-dir
        # see https://github.com/freebsd/freebsd-src/commit/f382bac49b1378da3c2dd66bf721beaa16b5d471
        + (
          if stdenv.targetPlatform.isFreeBSD then
            ''
              echo "-idirafter ${lib.getLib cc}/lib/clang/${clangVersion}/include" >> $out/nix-support/cc-cflags
            ''
          else
            ''
              ln -s "${lib.getLib cc}/lib/clang/${clangVersion}/include" "$rsrc"
            ''
        );

      mkExtraBuildCommandsBasicRt =
        cc:
        mkExtraBuildCommands0 cc
        + ''
          ln -s "${targetLlvmPackages.compiler-rt-no-libc.out}/lib" "$rsrc/lib"
        '';

      mkExtraBuildCommands =
        cc:
        mkExtraBuildCommands0 cc
        + ''
          ln -s "${targetLlvmPackages.compiler-rt.out}/lib" "$rsrc/lib"
          ln -s "${targetLlvmPackages.compiler-rt.out}/share" "$rsrc/share"
        '';

      bintoolsNoLibc' =
        if bootBintoolsNoLibc == null then llvmPackages.bintoolsNoLibc else bootBintoolsNoLibc;
      bintools' = if bootBintools == null then llvmPackages.bintools else bootBintools;
    in
    {
      libllvm = callPackage ./llvm { };
      libclang = callPackage ./clang { };
      clang-tools = callPackage ./clang-tools { };
      lld = callPackage ./lld { };
      openmp = callPackage ./openmp { };

      llvm = llvmPackages.libllvm;
      clang-unwrapped = llvmPackages.libclang;

      lldb = callPackage ./lldb (
        lib.optionalAttrs (lib.versions.major metadata.release_version == "16") {
          src = callPackage (
            { runCommand }:
            runCommand "lldb-src-${metadata.version}" { } ''
              mkdir -p "$out"
              cp -r ${monorepoSrc}/cmake "$out"
              cp -r ${monorepoSrc}/lldb "$out"
            ''
          ) { };
        }
      );

      bintools-unwrapped = callPackage ./bintools.nix { };

      tblgen = callPackage ./tblgen.nix {
        patches =
          builtins.filter
            # Crude method to drop polly patches if present, they're not needed for tblgen.
            (p: (!lib.hasInfix "-polly" p))
            llvmPackages.libllvm.patches;
        clangPatches = [
          # Would take tools.libclang.patches, but this introduces a cycle due
          # to replacements depending on the llvm outpath (e.g. the LLVMgold patch).
          # So take the only patch known to be necessary.
          (metadata.getVersionFile "clang/gnu-install-dirs.patch")
        ]
        ++
          lib.optional (stdenv.isAarch64 && lib.versions.major metadata.release_version == "17")
            # Fixes llvm17 tblgen builds on aarch64.
            # https://github.com/llvm/llvm-project/issues/106521#issuecomment-2337175680
            (metadata.getVersionFile "clang/aarch64-tblgen.patch");
      };

      clang =
        if stdenv.targetPlatform.libc == null then
          llvmPackages.clangNoLibc
        else if stdenv.targetPlatform.useLLVM or false then
          llvmPackages.clangUseLLVM
        else if (pkgs.targetPackages.stdenv or args.stdenv).cc.isGNU then
          llvmPackages.libstdcxxClang
        else
          llvmPackages.libcxxClang;

      llvm-manpages = lowPrio (
        llvmPackages.libllvm.override {
          enableManpages = true;
          python3 = pkgs.python3; # don't use python-boot
        }
      );

      clang-manpages = lowPrio (
        llvmPackages.libclang.override {
          enableManpages = true;
          python3 = pkgs.python3; # don't use python-boot
        }
      );

      bintoolsNoLibc = wrapBintoolsWith {
        bintools = llvmPackages.bintools-unwrapped;
        libc = targetPackages.preLibcHeaders;
      };

      bintools = wrapBintoolsWith {
        bintools = llvmPackages.bintools-unwrapped;
      };

      libstdcxxClang = wrapCCWith rec {
        cc = llvmPackages.clang-unwrapped;
        # libstdcxx is taken from gcc in an ad-hoc way in cc-wrapper.
        libcxx = null;
        extraPackages = [ targetLlvmPackages.compiler-rt ];
        extraBuildCommands = mkExtraBuildCommands cc;
      };

      libcxxClang = wrapCCWith rec {
        cc = llvmPackages.clang-unwrapped;
        libcxx = targetLlvmPackages.libcxx;
        extraPackages = [ targetLlvmPackages.compiler-rt ];
        extraBuildCommands = mkExtraBuildCommands cc;
      };

      clangUseLLVM = wrapCCWith (rec {
        cc = llvmPackages.clang-unwrapped;
        libcxx = targetLlvmPackages.libcxx;
        bintools = bintools';
        extraPackages = [
          targetLlvmPackages.compiler-rt
        ]
        ++ lib.optionals (!stdenv.targetPlatform.isWasm && !stdenv.targetPlatform.isFreeBSD) [
          targetLlvmPackages.libunwind
        ];
        extraBuildCommands = mkExtraBuildCommands cc;
        nixSupport.cc-cflags = [
          "-rtlib=compiler-rt"
          "-Wno-unused-command-line-argument"
          "-B${targetLlvmPackages.compiler-rt}/lib"
        ]
        ++ lib.optional (
          !stdenv.targetPlatform.isWasm && !stdenv.targetPlatform.isFreeBSD
        ) "--unwindlib=libunwind"
        ++ lib.optional (
          !stdenv.targetPlatform.isWasm
          && !stdenv.targetPlatform.isFreeBSD
          && stdenv.targetPlatform.useLLVM or false
        ) "-lunwind"
        ++ lib.optional stdenv.targetPlatform.isWasm "-fno-exceptions";
        nixSupport.cc-ldflags = lib.optionals (
          !stdenv.targetPlatform.isWasm && !stdenv.targetPlatform.isFreeBSD
        ) [ "-L${targetLlvmPackages.libunwind}/lib" ];
      });

      clangWithLibcAndBasicRtAndLibcxx = wrapCCWith (rec {
        cc = llvmPackages.clang-unwrapped;
        libcxx = targetLlvmPackages.libcxx;
        bintools = bintools';
        extraPackages = [
          targetLlvmPackages.compiler-rt-no-libc
        ]
        ++
          lib.optionals
            (
              !stdenv.targetPlatform.isWasm && !stdenv.targetPlatform.isFreeBSD && !stdenv.targetPlatform.isDarwin
            )
            [
              targetLlvmPackages.libunwind
            ];
        extraBuildCommands = mkExtraBuildCommandsBasicRt cc;
        nixSupport.cc-cflags = [
          "-rtlib=compiler-rt"
          "-Wno-unused-command-line-argument"
          "-B${targetLlvmPackages.compiler-rt-no-libc}/lib"
        ]
        ++ lib.optional (
          !stdenv.targetPlatform.isWasm && !stdenv.targetPlatform.isFreeBSD && !stdenv.targetPlatform.isDarwin
        ) "--unwindlib=libunwind"
        ++ lib.optional (
          !stdenv.targetPlatform.isWasm
          && !stdenv.targetPlatform.isFreeBSD
          && stdenv.targetPlatform.useLLVM or false
        ) "-lunwind"
        ++ lib.optional stdenv.targetPlatform.isWasm "-fno-exceptions";
        nixSupport.cc-ldflags = lib.optionals (
          !stdenv.targetPlatform.isWasm && !stdenv.targetPlatform.isFreeBSD && !stdenv.targetPlatform.isDarwin
        ) [ "-L${targetLlvmPackages.libunwind}/lib" ];
      });

      clangWithLibcAndBasicRt = wrapCCWith (rec {
        cc = llvmPackages.clang-unwrapped;
        libcxx = null;
        bintools = bintools';
        extraPackages = [ targetLlvmPackages.compiler-rt-no-libc ];
        extraBuildCommands = mkExtraBuildCommandsBasicRt cc;
        nixSupport.cc-cflags = [
          "-rtlib=compiler-rt"
          "-B${targetLlvmPackages.compiler-rt-no-libc}/lib"
          "-nostdlib++"
        ]
        ++ lib.optional (
          lib.versionAtLeast metadata.release_version "15" && stdenv.targetPlatform.isWasm
        ) "-fno-exceptions";
      });

      clangNoLibcWithBasicRt = wrapCCWith (rec {
        cc = llvmPackages.clang-unwrapped;
        libcxx = null;
        bintools = bintoolsNoLibc';
        extraPackages = [ targetLlvmPackages.compiler-rt-no-libc ];
        extraBuildCommands = mkExtraBuildCommandsBasicRt cc;
        nixSupport.cc-cflags = [
          "-rtlib=compiler-rt"
          "-B${targetLlvmPackages.compiler-rt-no-libc}/lib"
        ]
        ++ lib.optional (
          lib.versionAtLeast metadata.release_version "15" && stdenv.targetPlatform.isWasm
        ) "-fno-exceptions";
      });

      clangNoLibcNoRt = wrapCCWith (rec {
        cc = llvmPackages.clang-unwrapped;
        libcxx = null;
        bintools = bintoolsNoLibc';
        extraPackages = [ ];
        extraBuildCommands = mkExtraBuildCommands0 cc;
        # "-nostartfiles" used to be needed for pkgsLLVM, causes problems so don't include it.
        nixSupport.cc-cflags = lib.optional (
          lib.versionAtLeast metadata.release_version "15" && stdenv.targetPlatform.isWasm
        ) "-fno-exceptions";
      });

      # This is an "oddly ordered" bootstrap just for Darwin. Probably
      # don't want it otherwise.
      clangNoCompilerRtWithLibc = wrapCCWith rec {
        cc = llvmPackages.clang-unwrapped;
        libcxx = null;
        bintools = bintools';
        extraPackages = [ ];
        extraBuildCommands = mkExtraBuildCommands0 cc;
        nixSupport.cc-cflags = [ "-fno-exceptions" ];
      };

      # Aliases
      clangNoCompilerRt = llvmPackages.clangNoLibcNoRt;
      clangNoLibc = llvmPackages.clangNoLibcWithBasicRt;
      clangNoLibcxx = llvmPackages.clangWithLibcAndBasicRt;

      compiler-rt-libc = callPackage ./compiler-rt (
        let
          # temp rename to avoid infinite recursion
          stdenv =
            # Darwin needs to use a bootstrap stdenv to avoid an infinite recursion when cross-compiling.
            if args.stdenv.hostPlatform.isDarwin then
              overrideCC darwin.bootstrapStdenv buildLlvmPackages.clangWithLibcAndBasicRtAndLibcxx
            else if args.stdenv.hostPlatform.useLLVM or false then
              overrideCC args.stdenv buildLlvmPackages.clangWithLibcAndBasicRtAndLibcxx
            else
              args.stdenv;
        in
        {
          inherit stdenv;
        }
        // lib.optionalAttrs (stdenv.hostPlatform.useLLVM or false) {
          libxcrypt = (libxcrypt.override { inherit stdenv; }).overrideAttrs (old: {
            configureFlags = old.configureFlags ++ [ "--disable-symvers" ];
          });
        }
      );

      compiler-rt-no-libc = callPackage ./compiler-rt {
        doFakeLibgcc = stdenv.hostPlatform.useLLVM or false;
        stdenv =
          # Darwin needs to use a bootstrap stdenv to avoid an infinite recursion when cross-compiling.
          if stdenv.hostPlatform.isDarwin then
            overrideCC darwin.bootstrapStdenv buildLlvmPackages.clangNoLibcNoRt
          else
            overrideCC stdenv buildLlvmPackages.clangNoLibcNoRt;
      };

      compiler-rt =
        if
          stdenv.hostPlatform.libc == null
          # Building the with-libc compiler-rt and WASM doesn't yet work,
          # because wasilibc doesn't provide some expected things. See
          # compiler-rt's file for further details.
          || stdenv.hostPlatform.isWasm
          # Failing `#include <term.h>` in
          # `lib/sanitizer_common/sanitizer_platform_limits_freebsd.cpp`
          # sanitizers, not sure where to get it.
          || stdenv.hostPlatform.isFreeBSD
        then
          llvmPackages.compiler-rt-no-libc
        else
          llvmPackages.compiler-rt-libc;

      stdenv = overrideCC stdenv buildLlvmPackages.clang;

      libcxxStdenv = overrideCC stdenv buildLlvmPackages.libcxxClang;

      libcxx = callPackage ./libcxx (
        {
          stdenv =
            if stdenv.hostPlatform.isDarwin then
              overrideCC darwin.bootstrapStdenv buildLlvmPackages.clangWithLibcAndBasicRt
            else
              overrideCC stdenv buildLlvmPackages.clangWithLibcAndBasicRt;
        }
        // lib.optionalAttrs (lib.versionOlder metadata.release_version "14") {
          # TODO: remove this, causes LLVM 13 packages rebuild.
          inherit (metadata) monorepoSrc; # Preserve bug during #307211 refactor.
        }
      );

      libunwind = callPackage ./libunwind {
        stdenv = overrideCC stdenv buildLlvmPackages.clangWithLibcAndBasicRt;
      };
    }
    // lib.optionalAttrs (lib.versionAtLeast metadata.release_version "15") {
      # TODO: pre-15: lldb/docs/index.rst:155:toctree contains reference to nonexisting document 'design/structureddataplugins'
      lldb-manpages = lowPrio (
        llvmPackages.lldb.override {
          enableManpages = true;
          python3 = pkgs.python3; # don't use python-boot
        }
      );
    }
    // lib.optionalAttrs (lib.versionAtLeast metadata.release_version "16") {
      mlir = callPackage ./mlir { };
    }
    // lib.optionalAttrs (lib.versionAtLeast metadata.release_version "19") {
      bolt = callPackage ./bolt { };
    }
    //
      lib.optionalAttrs
        (lib.versionAtLeast metadata.release_version "16" && lib.versionOlder metadata.release_version "20")
        {
          libclc = callPackage ./libclc { };
        }
    // lib.optionalAttrs (lib.versionAtLeast metadata.release_version "20") {
      libc-overlay = callPackage ./libc {
        isFullBuild = false;
        # Use clang due to "gnu::naked" not working on aarch64.
        # Issue: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=77882
        stdenv = overrideCC stdenv buildLlvmPackages.clang;
      };

      libc-full = callPackage ./libc {
        isFullBuild = true;
        # Use clang due to "gnu::naked" not working on aarch64.
        # Issue: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=77882
        stdenv = overrideCC stdenv buildLlvmPackages.clangNoLibcNoRt;
        cmake =
          if stdenv.targetPlatform.libc == "llvm" then buildPackages.cmakeMinimal else buildPackages.cmake;
        python3 =
          if stdenv.targetPlatform.libc == "llvm" then
            buildPackages.python3Minimal
          else
            buildPackages.python3;
      };

      libc =
        if stdenv.targetPlatform.libc == "llvm" then llvmPackages.libc-full else llvmPackages.libc-overlay;
    };
}
