{
  lowPrio,
  newScope,
  pkgs,
  lib,
  stdenv,
  preLibcCrossHeaders,
  libxcrypt,
  substitute,
  substituteAll,
  fetchFromGitHub,
  fetchpatch,
  fetchpatch2,
  overrideCC,
  wrapCCWith,
  wrapBintoolsWith,
  buildLlvmTools, # tools, but from the previous stage, for cross
  targetLlvmLibraries, # libraries, but from the next stage, for cross
  targetLlvm,
  # This is the default binutils, but with *this* version of LLD rather
  # than the default LLVM version's, if LLD is the choice. We use these for
  # the `useLLVM` bootstrapping below.
  bootBintoolsNoLibc ? if stdenv.targetPlatform.linker == "lld" then null else pkgs.bintoolsNoLibc,
  bootBintools ? if stdenv.targetPlatform.linker == "lld" then null else pkgs.bintools,
  darwin,
  gitRelease ? null,
  officialRelease ? null,
  monorepoSrc ? null,
  version ? null,
  # Allows passthrough to packages via newScope. This makes it possible to
  # do `(llvmPackages.override { <someLlvmDependency> = bar; }).clang` and get
  # an llvmPackages whose packages are overridden in an internally consistent way.
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
            patches = {
              "clang/gnu-install-dirs.patch" = [
                {
                  before = "14";
                  path = ../12;
                }
                {
                  after = "19";
                  before = "20";
                  path = ../19;
                }
                {
                  after = "20";
                  path = ../git;
                }
              ];
              "clang/purity.patch" = [
                {
                  after = "18";
                  path = ../18;
                }
                {
                  before = "17";
                  after = "15";
                  path = ../15;
                }
                {
                  before = "16";
                  path = ../12;
                }
              ];
              "lld/add-table-base.patch" = [
                {
                  after = "16";
                  path = ../16;
                }
              ];
              "lld/gnu-install-dirs.patch" = [
                {
                  after = "18";
                  path = ../18;
                }
                {
                  before = "14";
                  path = ../12;
                }
              ];
              "llvm/gnu-install-dirs.patch" = [
                {
                  after = "18";
                  path = ../18;
                }
              ];
              "llvm/gnu-install-dirs-polly.patch" = [
                {
                  after = "18";
                  path = ../18;
                }
                {
                  before = "18";
                  after = "14";
                  path = ../14;
                }
              ];
              "llvm/llvm-lit-cfg-add-libs-to-dylib-path.patch" = [
                {
                  before = "17";
                  after = "15";
                  path = ../15;
                }
                {
                  after = "17";
                  path = ../17;
                }
              ];
              "llvm/lit-shell-script-runner-set-dyld-library-path.patch" = [
                {
                  after = "18";
                  path = ../18;
                }
                {
                  after = "16";
                  before = "18";
                  path = ../16;
                }
              ];
              "llvm/polly-lit-cfg-add-libs-to-dylib-path.patch" = [
                {
                  after = "15";
                  path = ../15;
                }
              ];
              "libcxx/0001-darwin-10.12-mbstate_t-fix.patch" = [
                {
                  after = "18";
                  path = ../18;
                }
              ];
              "libunwind/gnu-install-dirs.patch" = [
                {
                  before = "17";
                  after = "15";
                  path = ../15;
                }
              ];
              "compiler-rt/X86-support-extension.patch" = [
                {
                  after = "15";
                  path = ../15;
                }
                {
                  before = "15";
                  path = ../12;
                }
              ];
              "compiler-rt/armv7l.patch" = [
                {
                  before = "15";
                  after = "13";
                  path = ../13;
                }
              ];
              "compiler-rt/gnu-install-dirs.patch" = [
                {
                  before = "14";
                  path = ../12;
                }
                {
                  after = "13";
                  before = "15";
                  path = ../14;
                }
                {
                  after = "15";
                  before = "17";
                  path = ../15;
                }
                {
                  after = "16";
                  path = ../17;
                }
              ];
              "compiler-rt/darwin-targetconditionals.patch" = [
                {
                  after = "13";
                  path = ../13;
                }
              ];
              "compiler-rt/codesign.patch" = [
                {
                  after = "13";
                  path = ../13;
                }
              ];
              "compiler-rt/normalize-var.patch" = [
                {
                  after = "16";
                  path = ../16;
                }
                {
                  before = "16";
                  path = ../12;
                }
              ];
              "lldb/procfs.patch" = [
                {
                  after = "15";
                  path = ../15;
                }
                {
                  before = "15";
                  path = ../12;
                }
              ];
              "lldb/cpu_subtype_arm64e_replacement.patch" = [
                {
                  after = "13";
                  path = ../13;
                }
              ];
              "lldb/resource-dir.patch" = [
                {
                  before = "16";
                  path = ../12;
                }
              ];
              "openmp/fix-find-tool.patch" = [
                {
                  after = "17";
                  before = "19";
                  path = ../17;
                }
              ];
              "openmp/run-lit-directly.patch" = [
                {
                  after = "16";
                  path = ../16;
                }
                {
                  after = "14";
                  before = "16";
                  path = ../14;
                }
              ];
            };

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

  lldbPlugins = lib.makeExtensible (
    lldbPlugins:
    let
      callPackage = newScope (
        lldbPlugins
        // {
          inherit stdenv;
          inherit (tools) lldb;
        }
      );
    in
    lib.recurseIntoAttrs { llef = callPackage ./lldb-plugins/llef.nix { }; }
  );

  tools = lib.makeExtensible (
    tools:
    let
      callPackage = newScope (
        tools
        // args
        // metadata
        # Previously monorepoSrc was erroneously not being passed through.
        // lib.optionalAttrs (lib.versionOlder metadata.release_version "14") { monorepoSrc = null; } # Preserve a bug during #307211, TODO: remove; causes llvm 13 rebuild.
      );
      clangVersion =
        if (lib.versionOlder metadata.release_version "16") then
          metadata.release_version
        else
          lib.versions.major metadata.release_version;
      mkExtraBuildCommands0 = cc: ''
        rsrc="$out/resource-root"
        mkdir "$rsrc"
        ln -s "${cc.lib}/lib/clang/${clangVersion}/include" "$rsrc"
        echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
      '';
      mkExtraBuildCommandsBasicRt =
        cc:
        mkExtraBuildCommands0 cc
        + ''
          ln -s "${targetLlvmLibraries.compiler-rt-no-libc.out}/lib" "$rsrc/lib"
          ln -s "${targetLlvmLibraries.compiler-rt-no-libc.out}/share" "$rsrc/share"
        '';
      mkExtraBuildCommands =
        cc:
        mkExtraBuildCommands0 cc
        + ''
          ln -s "${targetLlvmLibraries.compiler-rt.out}/lib" "$rsrc/lib"
          ln -s "${targetLlvmLibraries.compiler-rt.out}/share" "$rsrc/share"
        '';

      bintoolsNoLibc' = if bootBintoolsNoLibc == null then tools.bintoolsNoLibc else bootBintoolsNoLibc;
      bintools' = if bootBintools == null then tools.bintools else bootBintools;
    in
    {
      libllvm = callPackage ./llvm {
        patches =
          lib.optional (lib.versionOlder metadata.release_version "14") ./llvm/llvm-config-link-static.patch
          ++ [ (metadata.getVersionFile "llvm/gnu-install-dirs.patch") ]
          ++ lib.optionals (lib.versionAtLeast metadata.release_version "15") [
            # Running the tests involves invoking binaries (like `opt`) that depend on
            # the LLVM dylibs and reference them by absolute install path (i.e. their
            # nix store path).
            #
            # Because we have not yet run the install phase (we're running these tests
            # as part of `checkPhase` instead of `installCheckPhase`) these absolute
            # paths do not exist yet; to work around this we point the loader (`ld` on
            # unix, `dyld` on macOS) at the `lib` directory which will later become this
            # package's `lib` output.
            #
            # Previously we would just set `LD_LIBRARY_PATH` to include the build `lib`
            # dir but:
            #   - this doesn't generalize well to other platforms; `lit` doesn't forward
            #     `DYLD_LIBRARY_PATH` (macOS):
            #     + https://github.com/llvm/llvm-project/blob/0d89963df354ee309c15f67dc47c8ab3cb5d0fb2/llvm/utils/lit/lit/TestingConfig.py#L26
            #   - even if `lit` forwarded this env var, we actually cannot set
            #     `DYLD_LIBRARY_PATH` in the child processes `lit` launches because
            #     `DYLD_LIBRARY_PATH` (and `DYLD_FALLBACK_LIBRARY_PATH`) is cleared for
            #     "protected processes" (i.e. the python interpreter that runs `lit`):
            #     https://stackoverflow.com/a/35570229
            #   - other LLVM subprojects deal with this issue by having their `lit`
            #     configuration set these env vars for us; it makes sense to do the same
            #     for LLVM:
            #     + https://github.com/llvm/llvm-project/blob/4c106cfdf7cf7eec861ad3983a3dd9a9e8f3a8ae/clang-tools-extra/test/Unit/lit.cfg.py#L22-L31
            #
            # !!! TODO: look into upstreaming this patch
            (metadata.getVersionFile "llvm/llvm-lit-cfg-add-libs-to-dylib-path.patch")

            # `lit` has a mode where it executes run lines as a shell script which is
            # constructs; this is problematic for macOS because it means that there's
            # another process in between `lit` and the binaries being tested. As noted
            # above, this means that `DYLD_LIBRARY_PATH` is cleared which means that our
            # tests fail with dyld errors.
            #
            # To get around this we patch `lit` to reintroduce `DYLD_LIBRARY_PATH`, when
            # present in the test configuration.
            #
            # It's not clear to me why this isn't an issue for LLVM developers running
            # on macOS (nothing about this _seems_ nix specific)..
            (metadata.getVersionFile "llvm/lit-shell-script-runner-set-dyld-library-path.patch")
          ]
          ++
            lib.optional (lib.versions.major metadata.release_version == "13")
              # Fix random compiler crashes: https://bugs.llvm.org/show_bug.cgi?id=50611
              (
                fetchpatch {
                  url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/4764a4f8c920912a2bfd8b0eea57273acfe0d8a8/trunk/no-strict-aliasing-DwarfCompileUnit.patch";
                  sha256 = "18l6mrvm2vmwm77ckcnbjvh6ybvn72rhrb799d4qzwac4x2ifl7g";
                  stripLen = 1;
                }
              )
          ++
            lib.optional (lib.versionOlder metadata.release_version "16")
              # Fix musl build.
              (
                fetchpatch {
                  url = "https://github.com/llvm/llvm-project/commit/5cd554303ead0f8891eee3cd6d25cb07f5a7bf67.patch";
                  relative = "llvm";
                  hash = "sha256-XPbvNJ45SzjMGlNUgt/IgEvM2dHQpDOe6woUJY+nUYA=";
                }
              )
          ++ lib.optionals (lib.versions.major metadata.release_version == "13") [
            # Backport gcc-13 fixes with missing includes.
            (fetchpatch {
              name = "signals-gcc-13.patch";
              url = "https://github.com/llvm/llvm-project/commit/ff1681ddb303223973653f7f5f3f3435b48a1983.patch";
              hash = "sha256-CXwYxQezTq5vdmc8Yn88BUAEly6YZ5VEIA6X3y5NNOs=";
              stripLen = 1;
            })
            (fetchpatch {
              name = "base64-gcc-13.patch";
              url = "https://github.com/llvm/llvm-project/commit/5e9be93566f39ee6cecd579401e453eccfbe81e5.patch";
              hash = "sha256-PAwrVrvffPd7tphpwCkYiz+67szPRzRB2TXBvKfzQ7U=";
              stripLen = 1;
            })
          ]
          ++ lib.optionals (lib.versions.major metadata.release_version == "14") [
            # fix RuntimeDyld usage on aarch64-linux (e.g. python312Packages.numba tests)
            (fetchpatch {
              url = "https://github.com/llvm/llvm-project/commit/2e1b838a889f9793d4bcd5dbfe10db9796b77143.patch";
              relative = "llvm";
              hash = "sha256-Ot45P/iwaR4hkcM3xtLwfryQNgHI6pv6ADjv98tgdZA=";
            })
          ]
          ++
            lib.optional (lib.versions.major metadata.release_version == "17")
              # resolves https://github.com/llvm/llvm-project/issues/75168
              (
                fetchpatch {
                  name = "fix-fzero-call-used-regs.patch";
                  url = "https://github.com/llvm/llvm-project/commit/f800c1f3b207e7bcdc8b4c7192928d9a078242a0.patch";
                  stripLen = 1;
                  hash = "sha256-e8YKrMy2rGcSJGC6er2V66cOnAnI+u1/yImkvsRsmg8=";
                }
              )
          ++ lib.optionals (lib.versions.major metadata.release_version == "18") [
            # Reorgs one test so the next patch applies
            (fetchpatch {
              name = "osabi-test-reorg.patch";
              url = "https://github.com/llvm/llvm-project/commit/06cecdc60ec9ebfdd4d8cdb2586d201272bdf6bd.patch";
              stripLen = 1;
              hash = "sha256-s9GZTNgzLS511Pzh6Wb1hEV68lxhmLWXjlybHBDMhvM=";
            })
            # Sets the OSABI for OpenBSD, needed for an LLD patch for OpenBSD.
            # https://github.com/llvm/llvm-project/pull/98553
            (fetchpatch {
              name = "mc-set-openbsd-osabi.patch";
              url = "https://github.com/llvm/llvm-project/commit/b64c1de714c50bec7493530446ebf5e540d5f96a.patch";
              stripLen = 1;
              hash = "sha256-fqw5gTSEOGs3kAguR4tINFG7Xja1RAje+q67HJt2nGg=";
            })
          ];
        pollyPatches =
          [ (metadata.getVersionFile "llvm/gnu-install-dirs-polly.patch") ]
          ++ lib.optional (lib.versionAtLeast metadata.release_version "15")
            # Just like the `llvm-lit-cfg` patch, but for `polly`.
            (metadata.getVersionFile "llvm/polly-lit-cfg-add-libs-to-dylib-path.patch");
      };

      # `llvm` historically had the binaries.  When choosing an output explicitly,
      # we need to reintroduce `outputSpecified` to get the expected behavior e.g. of lib.get*
      llvm = tools.libllvm;

      libclang = callPackage ./clang {
        patches =
          [
            (metadata.getVersionFile "clang/purity.patch")
            # https://reviews.llvm.org/D51899
            (metadata.getVersionFile "clang/gnu-install-dirs.patch")
          ]
          ++ lib.optional (lib.versions.major metadata.release_version == "13")
            # Revert of https://reviews.llvm.org/D100879
            # The malloc alignment assumption is incorrect for jemalloc and causes
            # mis-compilation in firefox.
            # See: https://bugzilla.mozilla.org/show_bug.cgi?id=1741454
            (metadata.getVersionFile "clang/revert-malloc-alignment-assumption.patch")
          ++ [
            ./clang/add-nostdlibinc-flag.patch
            (substituteAll {
              src =
                if (lib.versionOlder metadata.release_version "16") then
                  ./clang/clang-11-15-LLVMgold-path.patch
                else
                  ./clang/clang-at-least-16-LLVMgold-path.patch;
              libllvmLibdir = "${tools.libllvm.lib}/lib";
            })
          ]
          ++ lib.optional (lib.versions.major metadata.release_version == "18") (fetchpatch {
            name = "tweak-tryCaptureVariable-for-unevaluated-lambdas.patch";
            url = "https://github.com/llvm/llvm-project/commit/3d361b225fe89ce1d8c93639f27d689082bd8dad.patch";
            # TreeTransform.h is not affected in LLVM 18.
            excludes = [
              "docs/ReleaseNotes.rst"
              "lib/Sema/TreeTransform.h"
            ];
            stripLen = 1;
            hash = "sha256-1NKej08R9SPlbDY/5b0OKUsHjX07i9brR84yXiPwi7E=";
          });
      };

      clang-unwrapped = tools.libclang;

      llvm-manpages = lowPrio (
        tools.libllvm.override {
          enableManpages = true;
          python3 = pkgs.python3; # don't use python-boot
        }
      );

      clang-manpages = lowPrio (
        tools.libclang.override {
          enableManpages = true;
          python3 = pkgs.python3; # don't use python-boot
        }
      );

      # Wrapper for standalone command line utilities
      clang-tools = callPackage ./clang-tools { };

      # pick clang appropriate for package set we are targeting
      clang =
        if stdenv.targetPlatform.libc == null then
          tools.clangNoLibc
        else if stdenv.targetPlatform.useLLVM or false then
          tools.clangUseLLVM
        else if (pkgs.targetPackages.stdenv or args.stdenv).cc.isGNU then
          tools.libstdcxxClang
        else
          tools.libcxxClang;

      libstdcxxClang = wrapCCWith rec {
        cc = tools.clang-unwrapped;
        # libstdcxx is taken from gcc in an ad-hoc way in cc-wrapper.
        libcxx = null;
        extraPackages = [ targetLlvmLibraries.compiler-rt ];
        extraBuildCommands = mkExtraBuildCommands cc;
      };

      libcxxClang = wrapCCWith rec {
        cc = tools.clang-unwrapped;
        libcxx = targetLlvmLibraries.libcxx;
        extraPackages = [ targetLlvmLibraries.compiler-rt ];
        extraBuildCommands = mkExtraBuildCommands cc;
      };

      lld = callPackage ./lld {
        patches =
          [ (metadata.getVersionFile "lld/gnu-install-dirs.patch") ]
          ++ lib.optional (lib.versions.major metadata.release_version == "14") (
            metadata.getVersionFile "lld/fix-root-src-dir.patch"
          )
          ++ lib.optional (
            lib.versionAtLeast metadata.release_version "16" && lib.versionOlder metadata.release_version "18"
          ) (metadata.getVersionFile "lld/add-table-base.patch")
          ++ lib.optional (lib.versions.major metadata.release_version == "18") (
            # https://github.com/llvm/llvm-project/pull/97122
            fetchpatch {
              name = "more-openbsd-program-headers.patch";
              url = "https://github.com/llvm/llvm-project/commit/d7fd8b19e560fbb613159625acd8046d0df75115.patch";
              stripLen = 1;
              hash = "sha256-7wTy7XDTx0+fhWQpW1KEuz7xJvpl42qMTUfd20KGOfA=";
            }
          );
      };

      lldb = callPackage ./lldb.nix (
        {
          patches =
            let
              resourceDirPatch = callPackage (
                { substituteAll, libclang }:
                (substituteAll {
                  src = metadata.getVersionFile "lldb/resource-dir.patch";
                  clangLibDir = "${libclang.lib}/lib";
                }).overrideAttrs
                  (_: _: { name = "resource-dir.patch"; })
              ) { };
            in
            lib.optionals (lib.versionOlder metadata.release_version "15") [
              # Fixes for SWIG 4
              (fetchpatch2 {
                url = "https://github.com/llvm/llvm-project/commit/81fc5f7909a4ef5a8d4b5da2a10f77f7cb01ba63.patch?full_index=1";
                stripLen = 1;
                hash = "sha256-Znw+C0uEw7lGETQLKPBZV/Ymo2UigZS+Hv/j1mUo7p0=";
              })
              (fetchpatch2 {
                url = "https://github.com/llvm/llvm-project/commit/f0a25fe0b746f56295d5c02116ba28d2f965c175.patch?full_index=1";
                stripLen = 1;
                hash = "sha256-QzVeZzmc99xIMiO7n//b+RNAvmxghISKQD93U2zOgFI=";
              })
            ]
            ++ lib.optionals (lib.versionOlder metadata.release_version "16") [
              # Fixes for SWIG 4
              (fetchpatch2 {
                url = "https://github.com/llvm/llvm-project/commit/ba35c27ec9aa9807f5b4be2a0c33ca9b045accc7.patch?full_index=1";
                stripLen = 1;
                hash = "sha256-LXl+WbpmWZww5xMDrle3BM2Tw56v8k9LO1f1Z1/wDTs=";
              })
              (fetchpatch2 {
                url = "https://github.com/llvm/llvm-project/commit/9ec115978ea2bdfc60800cd3c21264341cdc8b0a.patch?full_index=1";
                stripLen = 1;
                hash = "sha256-u0zSejEjfrH3ZoMFm1j+NVv2t5AP9cE5yhsrdTS1dG4=";
              })

              # FIXME: do we need this after 15?
              (metadata.getVersionFile "lldb/procfs.patch")
            ]
            ++ lib.optional (lib.versionOlder metadata.release_version "17") resourceDirPatch
            ++ lib.optional (lib.versionOlder metadata.release_version "14") (
              metadata.getVersionFile "lldb/gnu-install-dirs.patch"
            )
            ++ lib.optional (lib.versionAtLeast metadata.release_version "14") ./lldb/gnu-install-dirs.patch
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
              stdenv.targetPlatform.isDarwin && lib.versionOlder stdenv.targetPlatform.darwinSdkVersion "11.0"
            ) (metadata.getVersionFile "lldb/cpu_subtype_arm64e_replacement.patch");
        }
        // lib.optionalAttrs (lib.versions.major metadata.release_version == "16") {
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

      # Below, is the LLVM bootstrapping logic. It handles building a
      # fully LLVM toolchain from scratch. No GCC toolchain should be
      # pulled in. As a consequence, it is very quick to build different
      # targets provided by LLVM and we can also build for what GCC
      # doesn’t support like LLVM. Probably we should move to some other
      # file.

      bintools-unwrapped = callPackage ./bintools.nix { };

      bintoolsNoLibc = wrapBintoolsWith {
        bintools = tools.bintools-unwrapped;
        libc = preLibcCrossHeaders;
      };

      bintools = wrapBintoolsWith { bintools = tools.bintools-unwrapped; };

      clangUseLLVM = wrapCCWith (
        rec {
          cc = tools.clang-unwrapped;
          libcxx = targetLlvmLibraries.libcxx;
          bintools = bintools';
          extraPackages =
            [ targetLlvmLibraries.compiler-rt ]
            ++ lib.optionals (!stdenv.targetPlatform.isWasm && !stdenv.targetPlatform.isFreeBSD) [
              targetLlvmLibraries.libunwind
            ];
          extraBuildCommands =
            lib.optionalString (lib.versions.major metadata.release_version == "13") (
              ''
                echo "-rtlib=compiler-rt -Wno-unused-command-line-argument" >> $out/nix-support/cc-cflags
                echo "-B${targetLlvmLibraries.compiler-rt}/lib" >> $out/nix-support/cc-cflags
              ''
              + lib.optionalString (!stdenv.targetPlatform.isWasm) ''
                echo "--unwindlib=libunwind" >> $out/nix-support/cc-cflags
                echo "-L${targetLlvmLibraries.libunwind}/lib" >> $out/nix-support/cc-ldflags
              ''
              + lib.optionalString (!stdenv.targetPlatform.isWasm && stdenv.targetPlatform.useLLVM or false) ''
                echo "-lunwind" >> $out/nix-support/cc-ldflags
              ''
              + lib.optionalString stdenv.targetPlatform.isWasm ''
                echo "-fno-exceptions" >> $out/nix-support/cc-cflags
              ''
            )
            + mkExtraBuildCommands cc;
        }
        // lib.optionalAttrs (lib.versionAtLeast metadata.release_version "14") {
          nixSupport.cc-cflags =
            [
              "-rtlib=compiler-rt"
              "-Wno-unused-command-line-argument"
              "-B${targetLlvmLibraries.compiler-rt}/lib"
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
          nixSupport.cc-ldflags =
            lib.optionals (!stdenv.targetPlatform.isWasm && !stdenv.targetPlatform.isFreeBSD)
              (
                [ "-L${targetLlvmLibraries.libunwind}/lib" ]
                ++ lib.optional (lib.versionAtLeast metadata.release_version "17") "--undefined-version"
              );
        }
      );

      clangWithLibcAndBasicRtAndLibcxx = wrapCCWith (
        rec {
          cc = tools.clang-unwrapped;
          libcxx = targetLlvmLibraries.libcxx;
          bintools = bintools';
          extraPackages =
            [ targetLlvmLibraries.compiler-rt-no-libc ]
            ++ lib.optionals (!stdenv.targetPlatform.isWasm && !stdenv.targetPlatform.isFreeBSD) [
              targetLlvmLibraries.libunwind
            ];
          extraBuildCommands =
            lib.optionalString (lib.versions.major metadata.release_version == "13") (
              ''
                echo "-rtlib=compiler-rt -Wno-unused-command-line-argument" >> $out/nix-support/cc-cflags
                echo "-B${targetLlvmLibraries.compiler-rt-no-libc}/lib" >> $out/nix-support/cc-cflags
              ''
              + lib.optionalString (!stdenv.targetPlatform.isWasm) ''
                echo "--unwindlib=libunwind" >> $out/nix-support/cc-cflags
                echo "-L${targetLlvmLibraries.libunwind}/lib" >> $out/nix-support/cc-ldflags
              ''
              + lib.optionalString (!stdenv.targetPlatform.isWasm && stdenv.targetPlatform.useLLVM or false) ''
                echo "-lunwind" >> $out/nix-support/cc-ldflags
              ''
              + lib.optionalString stdenv.targetPlatform.isWasm ''
                echo "-fno-exceptions" >> $out/nix-support/cc-cflags
              ''
            )
            + mkExtraBuildCommandsBasicRt cc;
        }
        // lib.optionalAttrs (lib.versionAtLeast metadata.release_version "14") {
          nixSupport.cc-cflags =
            [
              "-rtlib=compiler-rt"
              "-Wno-unused-command-line-argument"
              "-B${targetLlvmLibraries.compiler-rt-no-libc}/lib"
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
          ) [ "-L${targetLlvmLibraries.libunwind}/lib" ];
        }
      );

      clangWithLibcAndBasicRt = wrapCCWith (
        rec {
          cc = tools.clang-unwrapped;
          libcxx = null;
          bintools = bintools';
          extraPackages = [ targetLlvmLibraries.compiler-rt-no-libc ];
          extraBuildCommands =
            lib.optionalString (lib.versions.major metadata.release_version == "13") ''
              echo "-rtlib=compiler-rt" >> $out/nix-support/cc-cflags
              echo "-B${targetLlvmLibraries.compiler-rt-no-libc}/lib" >> $out/nix-support/cc-cflags
              echo "-nostdlib++" >> $out/nix-support/cc-cflags
            ''
            + mkExtraBuildCommandsBasicRt cc;
        }
        // lib.optionalAttrs (lib.versionAtLeast metadata.release_version "14") {
          nixSupport.cc-cflags =
            [
              "-rtlib=compiler-rt"
              "-B${targetLlvmLibraries.compiler-rt-no-libc}/lib"
              "-nostdlib++"
            ]
            ++ lib.optional (
              lib.versionAtLeast metadata.release_version "15" && stdenv.targetPlatform.isWasm
            ) "-fno-exceptions";
        }
      );

      clangNoLibcWithBasicRt = wrapCCWith (
        rec {
          cc = tools.clang-unwrapped;
          libcxx = null;
          bintools = bintoolsNoLibc';
          extraPackages = [ targetLlvmLibraries.compiler-rt-no-libc ];
          extraBuildCommands =
            lib.optionalString (lib.versions.major metadata.release_version == "13") ''
              echo "-rtlib=compiler-rt" >> $out/nix-support/cc-cflags
              echo "-B${targetLlvmLibraries.compiler-rt-no-libc}/lib" >> $out/nix-support/cc-cflags
            ''
            + mkExtraBuildCommandsBasicRt cc;
        }
        // lib.optionalAttrs (lib.versionAtLeast metadata.release_version "14") {
          nixSupport.cc-cflags =
            [
              "-rtlib=compiler-rt"
              "-B${targetLlvmLibraries.compiler-rt-no-libc}/lib"
            ]
            ++ lib.optional (
              lib.versionAtLeast metadata.release_version "15" && stdenv.targetPlatform.isWasm
            ) "-fno-exceptions";
        }
      );

      clangNoLibcNoRt = wrapCCWith (
        rec {
          cc = tools.clang-unwrapped;
          libcxx = null;
          bintools = bintoolsNoLibc';
          extraPackages = [ ];
          extraBuildCommands =
            lib.optionalString (lib.versions.major metadata.release_version == "13") ''
              echo "-nostartfiles" >> $out/nix-support/cc-cflags
            ''
            + mkExtraBuildCommands0 cc;
        }
        // lib.optionalAttrs (lib.versionAtLeast metadata.release_version "14") {
          nixSupport.cc-cflags =
            [ "-nostartfiles" ]
            ++ lib.optional (
              lib.versionAtLeast metadata.release_version "15" && stdenv.targetPlatform.isWasm
            ) "-fno-exceptions";
        }
      );

      # This is an "oddly ordered" bootstrap just for Darwin. Probably
      # don't want it otherwise.
      clangNoCompilerRtWithLibc =
        wrapCCWith rec {
          cc = tools.clang-unwrapped;
          libcxx = null;
          bintools = bintools';
          extraPackages = [ ];
          extraBuildCommands = mkExtraBuildCommands0 cc;
        }
        // lib.optionalAttrs (
          lib.versionAtLeast metadata.release_version "15" && stdenv.targetPlatform.isWasm
        ) { nixSupport.cc-cflags = [ "-fno-exceptions" ]; };

      # Aliases
      clangNoCompilerRt = tools.clangNoLibcNoRt;
      clangNoLibc = tools.clangNoLibcWithBasicRt;
      clangNoLibcxx = tools.clangWithLibcAndBasicRt;
    }
    // lib.optionalAttrs (lib.versionAtLeast metadata.release_version "15") {
      # TODO: pre-15: lldb/docs/index.rst:155:toctree contains reference to nonexisting document 'design/structureddataplugins'
      lldb-manpages = lowPrio (
        tools.lldb.override {
          enableManpages = true;
          python3 = pkgs.python3; # don't use python-boot
        }
      );
    }
    // lib.optionalAttrs (lib.versionAtLeast metadata.release_version "16") {
      mlir = callPackage ./mlir { };
      libclc = callPackage ./libclc.nix { };
    }
    // lib.optionalAttrs (lib.versionAtLeast metadata.release_version "19") {
      bolt = callPackage ./bolt {
        patches = lib.optionals (lib.versions.major metadata.release_version == "19") [
          (fetchpatch {
            url = "https://github.com/llvm/llvm-project/commit/abc2eae68290c453e1899a94eccc4ed5ea3b69c1.patch";
            hash = "sha256-oxCxOjhi5BhNBEraWalEwa1rS3Mx9CuQgRVZ2hrbd7M=";
          })
        ];
      };
    }
  );

  libraries = lib.makeExtensible (
    libraries:
    let
      callPackage = newScope (
        libraries
        // buildLlvmTools
        // args
        // metadata
        # Previously monorepoSrc was erroneously not being passed through.
        // lib.optionalAttrs (lib.versionOlder metadata.release_version "14") { monorepoSrc = null; } # Preserve a bug during #307211, TODO: remove; causes llvm 13 rebuild.
      );

      compiler-rtPatches =
        lib.optional (lib.versionOlder metadata.release_version "15") (
          metadata.getVersionFile "compiler-rt/codesign.patch"
        ) # Revert compiler-rt commit that makes codesign mandatory
        ++ [
          (metadata.getVersionFile "compiler-rt/X86-support-extension.patch") # Add support for i486 i586 i686 by reusing i386 config
        ]
        ++ lib.optional (
          lib.versionAtLeast metadata.release_version "14" && lib.versionOlder metadata.release_version "18"
        ) (metadata.getVersionFile "compiler-rt/gnu-install-dirs.patch")
        ++ [
          # ld-wrapper dislikes `-rpath-link //nix/store`, so we normalize away the
          # extra `/`.
          (metadata.getVersionFile "compiler-rt/normalize-var.patch")
        ]
        ++
          lib.optional (lib.versionOlder metadata.release_version "18")
            # Prevent a compilation error on darwin
            (metadata.getVersionFile "compiler-rt/darwin-targetconditionals.patch")
        ++
          lib.optional (lib.versionAtLeast metadata.release_version "15")
            # See: https://github.com/NixOS/nixpkgs/pull/186575
            ./compiler-rt/darwin-plistbuddy-workaround.patch
        ++
          lib.optional (lib.versions.major metadata.release_version == "15")
            # See: https://github.com/NixOS/nixpkgs/pull/194634#discussion_r999829893
            ./compiler-rt/armv7l-15.patch
        ++ lib.optionals (lib.versionOlder metadata.release_version "15") [
          ./compiler-rt/darwin-plistbuddy-workaround.patch
          (metadata.getVersionFile "compiler-rt/armv7l.patch")
          # Fix build on armv6l
          ./compiler-rt/armv6-mcr-dmb.patch
          ./compiler-rt/armv6-sync-ops-no-thumb.patch
          ./compiler-rt/armv6-no-ldrexd-strexd.patch
          ./compiler-rt/armv6-scudo-no-yield.patch
          ./compiler-rt/armv6-scudo-libatomic.patch
        ]
        ++ lib.optional (lib.versionAtLeast metadata.release_version "19") (fetchpatch {
          url = "https://github.com/llvm/llvm-project/pull/99837/commits/14ae0a660a38e1feb151928a14f35ff0f4487351.patch";
          hash = "sha256-JykABCaNNhYhZQxCvKiBn54DZ5ZguksgCHnpdwWF2no=";
          relative = "compiler-rt";
        });
    in
    {
      compiler-rt-libc = callPackage ./compiler-rt (
        let
          # temp rename to avoid infinite recursion
          stdenv =
            if args.stdenv.hostPlatform.useLLVM or false then
              overrideCC args.stdenv buildLlvmTools.clangWithLibcAndBasicRtAndLibcxx
            else if
              lib.versionAtLeast metadata.release_version "16"
              && args.stdenv.hostPlatform.isDarwin
              && args.stdenv.hostPlatform.isStatic
            then
              overrideCC args.stdenv buildLlvmTools.clangNoCompilerRtWithLibc
            else
              args.stdenv;
        in
        {
          patches = compiler-rtPatches;
          inherit stdenv;
        }
        // lib.optionalAttrs (stdenv.hostPlatform.useLLVM or false) {
          libxcrypt = (libxcrypt.override { inherit stdenv; }).overrideAttrs (old: {
            configureFlags = old.configureFlags ++ [ "--disable-symvers" ];
          });
        }
      );

      compiler-rt-no-libc = callPackage ./compiler-rt {
        patches = compiler-rtPatches;
        doFakeLibgcc = stdenv.hostPlatform.useLLVM or false;
        stdenv =
          if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform == stdenv.buildPlatform then
            stdenv
          else
            # TODO: make this branch unconditional next rebuild
            overrideCC stdenv buildLlvmTools.clangNoLibcNoRt;
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
          libraries.compiler-rt-no-libc
        else
          libraries.compiler-rt-libc;

      stdenv = overrideCC stdenv buildLlvmTools.clang;

      libcxxStdenv = overrideCC stdenv buildLlvmTools.libcxxClang;

      libcxx = callPackage ./libcxx (
        {
          patches =
            lib.optionals (lib.versionOlder metadata.release_version "16") (
              lib.optional (lib.versions.major metadata.release_version == "15")
                # See:
                #   - https://reviews.llvm.org/D133566
                #   - https://github.com/NixOS/nixpkgs/issues/214524#issuecomment-1429146432
                # !!! Drop in LLVM 16+
                (
                  fetchpatch {
                    url = "https://github.com/llvm/llvm-project/commit/57c7bb3ec89565c68f858d316504668f9d214d59.patch";
                    hash = "sha256-B07vHmSjy5BhhkGSj3e1E0XmMv5/9+mvC/k70Z29VwY=";
                  }
                )
              ++ [
                (substitute {
                  src = ./libcxxabi/wasm.patch;
                  substitutions = [
                    "--replace-fail"
                    "/cmake/"
                    "/llvm/cmake/"
                  ];
                })
              ]
              ++ lib.optional stdenv.hostPlatform.isMusl (substitute {
                src = ./libcxx/libcxx-0001-musl-hacks.patch;
                substitutions = [
                  "--replace-fail"
                  "/include/"
                  "/libcxx/include/"
                ];
              })
            )
            ++
              lib.optional
                (
                  lib.versions.major metadata.release_version == "17"
                  && stdenv.hostPlatform.isDarwin
                  && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "10.13"
                )
                # https://github.com/llvm/llvm-project/issues/64226
                (
                  fetchpatch {
                    name = "0042-mbstate_t-not-defined.patch";
                    url = "https://github.com/macports/macports-ports/raw/acd8acb171f1658596ed1cf25da48d5b932e2d19/lang/llvm-17/files/0042-mbstate_t-not-defined.patch";
                    hash = "sha256-jo+DYA6zuSv9OH3A0bYwY5TlkWprup4OKQ7rfK1WHBI=";
                  }
                )
            ++
              lib.optional
                (
                  lib.versionAtLeast metadata.release_version "18"
                  && stdenv.hostPlatform.isDarwin
                  && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "10.13"
                )
                # https://github.com/llvm/llvm-project/issues/64226
                (metadata.getVersionFile "libcxx/0001-darwin-10.12-mbstate_t-fix.patch");
          stdenv = overrideCC stdenv buildLlvmTools.clangWithLibcAndBasicRt;
        }
        // lib.optionalAttrs (lib.versionOlder metadata.release_version "14") {
          # TODO: remove this, causes LLVM 13 packages rebuild.
          inherit (metadata) monorepoSrc; # Preserve bug during #307211 refactor.
        }
      );

      libunwind = callPackage ./libunwind {
        patches = lib.optional (lib.versionOlder metadata.release_version "17") (
          metadata.getVersionFile "libunwind/gnu-install-dirs.patch"
        );
        stdenv = overrideCC stdenv buildLlvmTools.clangWithLibcAndBasicRt;
      };

      openmp = callPackage ./openmp {
        patches =
          lib.optional (
            lib.versionAtLeast metadata.release_version "15" && lib.versionOlder metadata.release_version "19"
          ) (metadata.getVersionFile "openmp/fix-find-tool.patch")
          ++ lib.optional (
            lib.versionAtLeast metadata.release_version "14" && lib.versionOlder metadata.release_version "18"
          ) (metadata.getVersionFile "openmp/gnu-install-dirs.patch")
          ++ lib.optional (lib.versionAtLeast metadata.release_version "14") (
            metadata.getVersionFile "openmp/run-lit-directly.patch"
          )
          ++
            lib.optional (lib.versionOlder metadata.release_version "14")
              # Fix cross.
              (
                fetchpatch {
                  url = "https://github.com/llvm/llvm-project/commit/5e2358c781b85a18d1463fd924d2741d4ae5e42e.patch";
                  hash = "sha256-UxIlAifXnexF/MaraPW0Ut6q+sf3e7y1fMdEv1q103A=";
                }
              );
      };
    }
  );

  noExtend = extensible: lib.attrsets.removeAttrs extensible [ "extend" ];
in
{
  inherit tools libraries lldbPlugins;
  inherit (metadata) release_version;
}
// (noExtend libraries)
// (noExtend tools)
