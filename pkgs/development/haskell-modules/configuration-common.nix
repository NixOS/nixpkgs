# COMMON OVERRIDES FOR THE HASKELL PACKAGE SET IN NIXPKGS
#
# This file contains haskell package overrides that are shared by all
# haskell package sets provided by nixpkgs and distributed via the official
# NixOS hydra instance.
#
# Overrides that would also make sense for custom haskell package sets not provided
# as part of nixpkgs and that are specific to Nix should go in configuration-nix.nix
#
# See comment at the top of configuration-nix.nix for more information about this
# distinction.
{ pkgs, haskellLib }:

self: super:

let
  inherit (pkgs) fetchpatch lib;
  inherit (lib) throwIfNot versionOlder;

  warnAfterVersion =
    ver: pkg:
    lib.warnIf (lib.versionOlder ver
      super.${pkg.pname}.version
    ) "override for haskellPackages.${pkg.pname} may no longer be needed" pkg;

in

with haskellLib;

# To avoid merge conflicts, consider adding your item at an arbitrary place in the list instead.
{
  # Hackage's accelerate is from 2020 and incompatible with our GHC.
  # The existing derivation also has missing dependencies
  # compared to the source from github.
  # https://github.com/AccelerateHS/accelerate/issues/553
  accelerate = lib.pipe super.accelerate [
    (warnAfterVersion "1.3.0.0")
    (addBuildDepends [
      self.double-conversion
      self.formatting
      self.microlens
    ])

    (overrideCabal (drv: {
      version = "1.3.0.0-unstable-2025-04-25";
      src = pkgs.fetchFromGitHub {
        owner = "AccelerateHS";
        repo = "accelerate";
        rev = "3f681a5091eddf5a3b97f4cd0de32adc830e1117";
        sha256 = "sha256-tCcl7wAls+5cBSrqbxfEAJngbV43OJcLJdaC4qqkBxc=";
      };
    }))
  ];

  # https://github.com/ivanperez-keera/dunai/issues/427
  dunai = addBuildDepend self.list-transformer (enableCabalFlag "list-transformer" super.dunai);

  # Make sure that Cabal_* can be built as-is
  Cabal_3_10_3_0 = doDistribute (
    super.Cabal_3_10_3_0.override {
      Cabal-syntax = self.Cabal-syntax_3_10_3_0;
    }
  );
  Cabal_3_12_1_0 = doDistribute (
    super.Cabal_3_12_1_0.override {
      Cabal-syntax = self.Cabal-syntax_3_12_1_0;
    }
  );
  Cabal_3_14_2_0 =
    overrideCabal
      (drv: {
        # Revert increased lower bound on unix since we have backported
        # the required patch to all GHC bundled versions of unix.
        postPatch = drv.postPatch or "" + ''
          substituteInPlace Cabal.cabal --replace-fail "unix  >= 2.8.6.0" "unix >= 2.6.0.0"
        '';
      })
      (
        doDistribute (
          super.Cabal_3_14_2_0.override {
            Cabal-syntax = self.Cabal-syntax_3_14_2_0;
          }
        )
      );

  # Needs matching version of Cabal
  Cabal-hooks = super.Cabal-hooks.override {
    Cabal = self.Cabal_3_14_2_0;
  };

  # Needs Cabal>=3.14
  cabal-lenses = super.cabal-lenses.override {
    Cabal = self.Cabal_3_14_2_0;
  };

  # cabal-install needs most recent versions of Cabal and Cabal-syntax,
  # so we need to put some extra work for non-latest GHCs
  inherit
    (
      let
        # !!! Use cself/csuper inside for the actual overrides
        cabalInstallOverlay = cself: csuper: {
          Cabal = cself.Cabal_3_14_2_0;
          Cabal-syntax = cself.Cabal-syntax_3_14_2_0;

          # Only needed for cabal2nix, hpack < 0.37 forbids Cabal >= 3.14
          hpack = cself.hpack_0_38_1;
        };
      in
      {
        cabal-install =
          let
            cabal-install = super.cabal-install.overrideScope cabalInstallOverlay;
            scope = cabal-install.scope;
          in
          # Some dead code is not properly eliminated on aarch64-darwin, leading
          # to bogus references to some dependencies.
          overrideCabal (
            old:
            {
              # Prevent DOS line endings from Hackage from breaking a patch
              prePatch = old.prePatch or "" + ''
                ${pkgs.buildPackages.dos2unix}/bin/dos2unix *.cabal
              '';
              # Ignore unix bound intended to prevent an unix bug on 32bit systems.
              # We apply a patch for this issue to the GHC core packages directly.
              # See unix-fix-ctimeval-size-32-bit.patch in ../compilers/ghc/common-*.nix
              patches =
                old.patches or [ ]
                ++
                  lib.optionals
                    (
                      scope.unix == null
                      && lib.elem self.ghc.version [
                        "9.6.1"
                        "9.6.2"
                        "9.6.3"
                        "9.6.4"
                        "9.6.5"
                        "9.6.6"
                        "9.8.1"
                        "9.8.2"
                        "9.8.3"
                        "9.10.1"
                      ]
                    )
                    [
                      ./patches/cabal-install-3.14.1.1-lift-unix-bound.patch
                    ];
            }
            // lib.optionalAttrs (pkgs.stdenv.hostPlatform.isDarwin && pkgs.stdenv.hostPlatform.isAarch64) {
              postInstall = ''
                ${old.postInstall or ""}
                remove-references-to -t ${scope.HTTP} "$out/bin/.cabal-wrapped"
                # if we don't override Cabal, it is taken from ghc's core libs
                remove-references-to -t ${
                  if scope.Cabal != null then scope.Cabal else scope.ghc
                } "$out/bin/.cabal-wrapped"
              '';
            }
          ) cabal-install;

        cabal-install-solver = super.cabal-install-solver.overrideScope cabalInstallOverlay;

        # Needs cabal-install >= 3.8 /as well as/ matching Cabal
        guardian = lib.pipe (super.guardian.overrideScope cabalInstallOverlay) [
          # Tests need internet access (run stack)
          dontCheck
          # May as well…
          (self.generateOptparseApplicativeCompletions [ "guardian" ])
        ];

        cabal2nix-unstable = super.cabal2nix-unstable.overrideScope cabalInstallOverlay;
        distribution-nixpkgs-unstable = super.distribution-nixpkgs-unstable.overrideScope cabalInstallOverlay;
        hackage-db-unstable = super.hackage-db-unstable.overrideScope cabalInstallOverlay;
      }
    )
    cabal-install
    cabal-install-solver
    guardian
    cabal2nix-unstable
    distribution-nixpkgs-unstable
    hackage-db-unstable
    ;

  # Expected test output for these accidentally checks the absolute location of the source directory
  # https://github.com/dan-t/cabal-cargs/issues/9
  cabal-cargs = overrideCabal (drv: {
    testFlags = drv.testFlags or [ ] ++ [
      "-p"
      "!/FindCabalFilePure withoutSandbox/"
      "-p"
      "!/FromCabalFilePure withoutSandbox/"
      "-p"
      "!/FromLibSrcPure withoutSandbox/"
      "-p"
      "!/FromExeSrcFilePure withoutSandbox/"
      "-p"
      "!/FindCabalFilePure withSandbox/"
      "-p"
      "!/FromCabalFilePure withSandbox/"
      "-p"
      "!/FromLibSrcPure withSandbox/"
      "-p"
      "!/FromExeSrcFilePure withSandbox/"
    ];
  }) super.cabal-cargs;

  # Extensions wants the latest version of Cabal for its list of Haskell
  # language extensions.
  # 2025-02-10: jailbreak to allow hspec-hedgehog 0.3.0.0 and hedgehog 1.5
  extensions = doJailbreak (
    super.extensions.override {
      Cabal = if versionOlder self.ghc.version "9.6" then self.Cabal_3_10_3_0 else null; # use GHC bundled version
    }
  );

  #######################################
  ### HASKELL-LANGUAGE-SERVER SECTION ###
  #######################################

  # All jailbreaks in this section due to: https://github.com/haskell/haskell-language-server/pull/4316#discussion_r1667684895
  haskell-language-server =
    lib.pipe
      (super.haskell-language-server.overrideScope (
        lself: lsuper: {
          # For most ghc versions, we overrideScope Cabal in the configuration-ghc-???.nix,
          # because some packages, like ormolu, need a newer Cabal version.
          # ghc-paths is special because it depends on Cabal for building
          # its Setup.hs, and therefor declares a Cabal dependency, but does
          # not actually use it as a build dependency.
          # That means ghc-paths can just use the ghc included Cabal version,
          # without causing package-db incoherence and we should do that because
          # otherwise we have different versions of ghc-paths
          # around which have the same abi-hash, which can lead to confusions and conflicts.
          ghc-paths = lsuper.ghc-paths.override { Cabal = null; };
        }
      ))
      [
        dontCheck
      ];

  # For -f-auto see cabal.project in haskell-language-server.
  ghc-lib-parser-ex = addBuildDepend self.ghc-lib-parser (
    disableCabalFlag "auto" super.ghc-lib-parser-ex
  );

  ###########################################
  ### END HASKELL-LANGUAGE-SERVER SECTION ###
  ###########################################

  # Test ldap server test/ldap.js is missing from sdist
  # https://github.com/supki/ldap-client/issues/18
  ldap-client-og = dontCheck super.ldap-client-og;

  # Support for template-haskell >= 2.16
  language-haskell-extract = appendPatch (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/language-haskell-extract-0.2.4.patch";
    sha256 = "0w4y3v69nd3yafpml4gr23l94bdhbmx8xky48a59lckmz5x9fgxv";
  }) (doJailbreak super.language-haskell-extract);

  vector = overrideCabal (old: {
    # vector-doctest seems to be broken when executed via ./Setup test
    testTargets = [
      "vector-tests-O0"
      "vector-tests-O2"
    ];
  }) super.vector;

  # https://github.com/lspitzner/data-tree-print/issues/4
  data-tree-print = doJailbreak super.data-tree-print;

  # jacinda needs latest version of alex and happy
  jacinda = super.jacinda.override {
    happy = self.happy_2_1_5;
  };

  # Test suite hangs on 32bit. Unclear if this is a bug or not, but if so, then
  # it has been present in past versions as well.
  # https://github.com/haskell-unordered-containers/unordered-containers/issues/491
  unordered-containers =
    if pkgs.stdenv.hostPlatform.is32bit then
      dontCheck super.unordered-containers
    else
      super.unordered-containers;

  aeson =
    # aeson's test suite includes some tests with big numbers that fail on 32bit
    # https://github.com/haskell/aeson/issues/1060
    dontCheckIf pkgs.stdenv.hostPlatform.is32bit
      # Deal with infinite and NaN values generated by QuickCheck-2.14.3
      super.aeson;

  time-compat = overrideCabal (drv: {
    testFlags = drv.testFlags or [ ] ++ [
      "-p"
      (lib.concatStringsSep "&&" [
        # Precision tests often fail in VMs:
        # https://github.com/haskellari/time-compat/issues/31
        "!/getCurrentTime/"
        "!/taiClock/"
      ])
    ];
  }) super.time-compat;

  # 2023-06-28: Test error: https://hydra.nixos.org/build/225565149
  orbits = dontCheck super.orbits;

  # 2025-02-10: Too strict bounds on tasty-quickcheck < 0.11
  tasty-discover = doJailbreak super.tasty-discover;

  # 2025-02-10: Too strict bounds on tasty < 1.5
  tasty-hunit-compat = doJailbreak super.tasty-hunit-compat;

  # Out of date test data: https://github.com/ocharles/weeder/issues/176
  weeder = appendPatch (pkgs.fetchpatch {
    name = "weeder-2.9.0-test-fix-expected.patch";
    url = "https://github.com/ocharles/weeder/commit/56028d0c80fe89d4f2ae25275aedb72714fec7da.patch";
    sha256 = "10zkvclyir3zf21v41zdsvg68vrkq89n64kv9k54742am2i4aygf";
  }) super.weeder;

  # Test suite doesn't find necessary test files when compiling
  # https://github.com/yesodweb/shakespeare/issues/294
  shakespeare = dontCheck super.shakespeare;

  # Work around -Werror failures until a more permanent solution is released
  # https://github.com/haskell-cryptography/HsOpenSSL/issues/88
  # https://github.com/haskell-cryptography/HsOpenSSL/issues/93
  # https://github.com/haskell-cryptography/HsOpenSSL/issues/95
  HsOpenSSL = appendConfigureFlags [
    "--ghc-option=-optc=-Wno-error=incompatible-pointer-types"
  ] super.HsOpenSSL;
  # Work around compilation failures with gcc >= 14
  # https://github.com/audreyt/hssyck/issues/5
  HsSyck = appendConfigureFlags [
    "--ghc-option=-optc=-Wno-error=implicit-function-declaration"
  ] super.HsSyck;
  # https://github.com/rethab/bindings-dsl/issues/46
  bindings-libcddb = appendConfigureFlags [
    "--ghc-option=-optc=-Wno-error=incompatible-pointer-types"
  ] super.bindings-libcddb;
  # https://github.com/ocramz/hdf5-lite/issues/3
  hdf5-lite = appendConfigureFlags [
    "--ghc-option=-optc=-Wno-error=implicit-function-declaration"
  ] super.hdf5-lite;
  # https://github.com/awkward-squad/termbox/issues/5
  termbox-bindings-c = appendConfigureFlags [
    "--ghc-option=-optc=-Wno-error=implicit-function-declaration"
  ] super.termbox-bindings-c;

  # There are numerical tests on random data, that may fail occasionally
  lapack = dontCheck super.lapack;

  # support for transformers >= 0.6
  lifted-base = appendPatch (fetchpatch {
    url = "https://github.com/basvandijk/lifted-base/commit/6b61483ec7fd0d5d5d56ccb967860d42740781e8.patch";
    sha256 = "sha256-b29AVDiEMcShceRJyKEauK/411UkOh3ME9AnKEYvcEs=";
  }) super.lifted-base;

  leveldb-haskell = overrideCabal (drv: {
    version = "2024-05-05-unstable";
    # Fix tests on mtl ≥ 2.3
    # https://github.com/kim/leveldb-haskell/pull/42
    src = pkgs.fetchFromGitHub {
      owner = "kim";
      repo = "leveldb-haskell";
      rev = "3a505f3a7de0f5d14463538d7c2c9a9881a60eb9";
      sha256 = "sha256-okUn5ZuWcj8vPr0GWXvO1LygNCrDfttkDaUoOt+FLA0=";
    };
  }) super.leveldb-haskell;

  # 2024-06-23: Hourglass is archived and had its last commit 6 years ago.
  # Patch is needed to add support for time 1.10, which is only used in the tests
  # https://github.com/vincenthz/hs-hourglass/pull/56
  # Jailbreak is needed because a hackage revision added the (correct) time <1.10 bound.
  hourglass = doJailbreak (
    appendPatches [
      (pkgs.fetchpatch {
        name = "hourglass-pr-56.patch";
        url = "https://github.com/vincenthz/hs-hourglass/commit/cfc2a4b01f9993b1b51432f0a95fa6730d9a558a.patch";
        sha256 = "sha256-gntZf7RkaR4qzrhjrXSC69jE44SknPDBmfs4z9rVa5Q=";
      })
    ] super.hourglass
  );

  # Arion's test suite needs a Nixpkgs, which is cumbersome to do from Nixpkgs
  # itself. For instance, pkgs.path has dirty sources and puts a huge .git in the
  # store. Testing is done upstream.
  arion-compose = dontCheck super.arion-compose;

  # 2023-07-17: Outdated base bound https://github.com/srid/lvar/issues/5
  lvar = doJailbreak super.lvar;

  # Don't call setEnv in parallel in the test suite (which leads to flaky failures)
  env-extra =
    appendPatches
      [
        (pkgs.fetchpatch {
          name = "env-extra-no-parallel-setenv.patch";
          url = "https://github.com/d12frosted/env-extra/commit/4fcbc031b210e71e4243fcfe7c48d381e2f51d78.patch";
          sha256 = "sha256-EbXk+VOmxMJAMCMTXpTiW8fkbNI9za7f1alzCeaJaV4=";
          excludes = [ "package.yaml" ];
        })
      ]
      (
        overrideCabal (drv: {
          prePatch = ''
            ${drv.prePatch or ""}
            ${lib.getExe' pkgs.buildPackages.dos2unix "dos2unix"} *.cabal
          '';
        }) super.env-extra
      );

  # This used to be a core package provided by GHC, but then the compiler
  # dropped it. We define the name here to make sure that old packages which
  # depend on this library still evaluate (even though they won't compile
  # successfully with recent versions of the compiler).
  bin-package-db = null;

  # waiting for release: https://github.com/jwiegley/c2hsc/issues/41
  c2hsc = appendPatch (fetchpatch {
    url = "https://github.com/jwiegley/c2hsc/commit/490ecab202e0de7fc995eedf744ad3cb408b53cc.patch";
    sha256 = "1c7knpvxr7p8c159jkyk6w29653z5yzgjjqj11130bbb8mk9qhq7";
  }) super.c2hsc;

  # 2025-02-10: Too strict bounds on bytestring < 0.12
  ghc-debug-common = doJailbreak super.ghc-debug-common;

  # https://github.com/agrafix/superbuffer/issues/4
  # Too strict bounds on bytestring < 0.12
  superbuffer = doJailbreak super.superbuffer;

  # Infinite recursion with test enabled.
  # 2025-02-14: Too strict bounds on attoparsec < 0.14
  attoparsec-varword = doJailbreak (dontCheck super.attoparsec-varword);

  # These packages (and their reverse deps) cannot be built with profiling enabled.
  ghc-heap-view = disableLibraryProfiling super.ghc-heap-view;
  ghc-datasize = disableLibraryProfiling super.ghc-datasize;
  ghc-vis = disableLibraryProfiling super.ghc-vis;

  # Fix 32bit struct being used for 64bit syscall on 32bit platforms
  # https://github.com/haskellari/lukko/issues/15
  lukko = appendPatches [
    (fetchpatch {
      name = "lukko-ofd-locking-32bit.patch";
      url = "https://github.com/haskellari/lukko/pull/32/commits/4e69ffad996c3771f50017b97375af249dd17c85.patch";
      sha256 = "0n8vig48irjz0jckc20dzc23k16fl5hznrc0a81y02ms72msfwi1";
    })
  ] super.lukko;

  # Relax version constraints (network < 3.2, text < 2.1)
  # https://github.com/essandess/adblock2privoxy/pull/43
  adblock2privoxy = doJailbreak super.adblock2privoxy;

  # Missing test file https://gitlab.com/dpwiz/hs-jpeg-turbo/-/issues/1
  jpeg-turbo = dontCheck super.jpeg-turbo;
  JuicyPixels-jpeg-turbo = dontCheck super.JuicyPixels-jpeg-turbo;

  # Fixes compilation for basement on i686 for GHC >= 9.4
  # https://github.com/haskell-foundation/foundation/pull/573
  # Patch would not work for GHC >= 9.2 where it breaks compilation on x86_64
  # https://github.com/haskell-foundation/foundation/pull/573#issuecomment-1669468867
  # TODO(@sternenseemann): make unconditional
  basement = appendPatches (lib.optionals pkgs.stdenv.hostPlatform.is32bit [
    (fetchpatch {
      name = "basement-i686-ghc-9.4.patch";
      url = "https://github.com/haskell-foundation/foundation/pull/573/commits/38be2c93acb6f459d24ed6c626981c35ccf44095.patch";
      sha256 = "17kz8glfim29vyhj8idw8bdh3id5sl9zaq18zzih3schfvyjppj7";
      stripLen = 1;
    })
  ]) super.basement;

  # Fixes compilation of memory with GHC >= 9.4 on 32bit platforms
  # https://github.com/vincenthz/hs-memory/pull/99
  memory = appendPatches (lib.optionals pkgs.stdenv.hostPlatform.is32bit [
    (fetchpatch {
      name = "memory-i686-ghc-9.4.patch";
      url = "https://github.com/vincenthz/hs-memory/pull/99/commits/2738929ce15b4c8704bbbac24a08539b5d4bf30e.patch";
      sha256 = "196rj83iq2k249132xsyhbbl81qi1j23h9pa6mmk6zvxpcf63yfw";
    })
  ]) super.memory;

  # Depends on outdated deps hedgehog < 1.4, doctest < 0.12 for tests
  # As well as deepseq < 1.5 (so it forbids GHC 9.8)
  hw-fingertree = doJailbreak super.hw-fingertree;

  # Test suite is slow and sometimes comes up with counter examples.
  # Upstream is aware (https://github.com/isovector/nspace/issues/1),
  # if it's a bug, at least doesn't seem to be nixpkgs-specific.
  nspace = dontCheck super.nspace;

  # Unreleased commits relaxing bounds on various dependencies
  gitit = appendPatches [
    (fetchpatch {
      name = "gitit-allow-hoauth2-2.14.patch";
      url = "https://github.com/jgm/gitit/commit/58a226c48b37f076ccc1b94ad88a9ffc05f983cc.patch";
      sha256 = "1fvfzbas18vsv9qvddp6g82hy9hdgz34n51w6dpkd7cm4sl07pjv";
    })
    (fetchpatch {
      name = "gitit-allow-pandoc-3.6.patch";
      url = "https://github.com/jgm/gitit/commit/c57c790fa0db81d383f22901a0db4ffe90f1bfcc.patch";
      sha256 = "0nbzxyc9gkhkag1fhv3qmw5zgblhbz0axrlsismrcvdzr28amii8";
    })
    (fetchpatch {
      name = "gitit-allow-zlib-0.7-network-3.2.patch";
      url = "https://github.com/jgm/gitit/commit/efaee62bc32c558e618ad34458fa2ef85cb8eb1e.patch";
      sha256 = "1ghky3afnib56w102mh09cz2alfyq743164mnjywwfl6a6yl6i5h";
    })
  ] super.gitit;

  # https://github.com/schuelermine/ret/issues/3
  ret = doJailbreak super.ret; # base < 4.19

  # The latest release on hackage has an upper bound on containers which
  # breaks the build, though it works with the version of containers present
  # and the upper bound doesn't exist in code anymore:
  # > https://github.com/roelvandijk/numerals
  numerals = doJailbreak (dontCheck super.numerals);

  # Bound on containers is too strict but jailbreak doesn't work with conditional flags
  # https://github.com/NixOS/jailbreak-cabal/issues/24
  containers-unicode-symbols = overrideCabal {
    postPatch = ''
      substituteInPlace containers-unicode-symbols.cabal \
        --replace 'containers >= 0.5 && < 0.6.5' 'containers'
    '';
  } super.containers-unicode-symbols;

  # Test file not included on hackage
  numerals-base = dontCheck (doJailbreak super.numerals-base);

  # This test keeps being aborted because it runs too quietly for too long
  Lazy-Pbkdf2 =
    if pkgs.stdenv.hostPlatform.isi686 then dontCheck super.Lazy-Pbkdf2 else super.Lazy-Pbkdf2;

  # check requires mysql server
  mysql-simple = dontCheck super.mysql-simple;

  # Test data missing
  # https://github.com/FPtje/GLuaFixer/issues/165
  glualint = dontCheck super.glualint;

  # Hackage tarball only includes what is supported by `cabal install git-annex`,
  # but we want e.g. completions as well. See
  # https://web.archive.org/web/20160724083703/https://git-annex.branchable.com/bugs/bash_completion_file_is_missing_in_the_6.20160527_tarball_on_hackage/
  # or git-annex @ 3571b077a1244330cc736181ee04b4d258a78476 doc/bugs/bash_completion_file_is_missing*
  git-annex = lib.pipe super.git-annex (
    [
      (overrideCabal (drv: {
        src = pkgs.fetchgit {
          name = "git-annex-${super.git-annex.version}-src";
          url = "git://git-annex.branchable.com/";
          rev = "refs/tags/" + super.git-annex.version;
          sha256 = "sha256-whpBFmOHBTm1clXoAwInsQw7mnxrQOyaUj7byogku5c=";
          # delete android and Android directories which cause issues on
          # darwin (case insensitive directory). Since we don't need them
          # during the build process, we can delete it to prevent a hash
          # mismatch on darwin.
          postFetch = ''
            rm -r $out/doc/?ndroid*
          '';
        };

        patches = drv.patches or [ ] ++ [
          # Prevent .desktop files from being installed to $out/usr/share.
          # TODO(@sternenseemann): submit upstreamable patch resolving this
          # (this should be possible by also taking PREFIX into account).
          ./patches/git-annex-no-usr-prefix.patch
          # https://git-annex.branchable.com/bugs/flaky_test_failure_add_dup/
          (pkgs.fetchpatch {
            name = "git-annex-workaround-for-git-2.50_bis.patch";
            url = "https://git.joeyh.name/index.cgi/git-annex.git/patch/?id=cf449837ea9ab7687d8a157f21cad31ddf5bbfb6";
            sha256 = "sha256-HmNJ85dLht5Hy85AUkjACnET9YLPP2MshYHsApUax+I=";
            excludes = [
              "doc/**"
              "CHANGELOG"
            ];
          })
        ];

        postPatch = ''
          substituteInPlace Makefile \
            --replace-fail 'InstallDesktopFile $(PREFIX)/bin/git-annex' \
                           'InstallDesktopFile git-annex'
        '';
      }))
    ]
    ++ lib.optionals (lib.versionOlder self.ghc.version "9.10") [
      (disableCabalFlag "OsPath")
      (addBuildDepends [ self.filepath-bytestring ])
    ]
  );

  # Too strict bounds on servant
  # Pending a hackage revision: https://github.com/berberman/arch-web/commit/5d08afee5b25e644f9e2e2b95380a5d4f4aa81ea#commitcomment-89230555
  arch-web = doJailbreak super.arch-web;

  # Fix test trying to access /home directory
  shell-conduit = overrideCabal (drv: {
    postPatch = "sed -i s/home/tmp/ test/Spec.hs";
  }) super.shell-conduit;

  # https://github.com/serokell/nixfmt/issues/130
  nixfmt = doJailbreak super.nixfmt;

  # Too strict upper bounds on turtle and text
  # https://github.com/awakesecurity/nix-deploy/issues/35
  nix-deploy = doJailbreak super.nix-deploy;

  # Too strict upper bound on algebraic-graphs
  # https://github.com/awakesecurity/nix-graph/issues/5
  nix-graph = doJailbreak super.nix-graph;

  # Too strict bounds on hspec
  # https://github.com/illia-shkroba/pfile/issues/2
  pfile = doJailbreak super.pfile;

  # Manually maintained
  cachix-api = overrideCabal (drv: {
    version = "1.7.9";
    src = pkgs.fetchFromGitHub {
      owner = "cachix";
      repo = "cachix";
      tag = "v1.7.9";
      hash = "sha256-R0W7uAg+BLoHjMRMQ8+oiSbTq8nkGz5RDpQ+ZfxxP3A=";
    };
    postUnpack = "sourceRoot=$sourceRoot/cachix-api";
  }) super.cachix-api;
  cachix = (
    overrideCabal
      (drv: {
        version = "1.7.9";
        src = pkgs.fetchFromGitHub {
          owner = "cachix";
          repo = "cachix";
          tag = "v1.7.9";
          hash = "sha256-R0W7uAg+BLoHjMRMQ8+oiSbTq8nkGz5RDpQ+ZfxxP3A=";
        };
        postUnpack = "sourceRoot=$sourceRoot/cachix";
      })
      (
        lib.pipe
          (super.cachix.override {
            nix = self.hercules-ci-cnix-store.nixPackage;
          })
          [
            (addBuildTool self.hercules-ci-cnix-store.nixPackage)
            (addBuildTool pkgs.buildPackages.pkg-config)
            (addBuildDepend self.hnix-store-nar)
          ]
      )
  );

  # Overly strict bounds on postgresql-simple (< 0.7), tasty (< 1.5) and tasty-quickcheck (< 0.11)
  # https://github.com/tdammers/migrant/pull/5
  migrant-core = doJailbreak super.migrant-core;
  migrant-sqlite-simple = doJailbreak super.migrant-sqlite-simple;
  migrant-hdbc = doJailbreak super.migrant-hdbc;
  migrant-postgresql-simple = lib.pipe super.migrant-postgresql-simple [
    (overrideCabal {
      preCheck = ''
        postgresqlTestUserOptions="LOGIN SUPERUSER"
      '';
    })
    (addTestToolDepends [
      pkgs.postgresql
      pkgs.postgresqlTestHook
    ])
    doJailbreak
  ];

  # https://github.com/froozen/kademlia/issues/2
  kademlia = dontCheck super.kademlia;

  # Tests require older versions of tasty.
  hzk = dontCheck super.hzk;

  # Test suite doesn't compile with 9.6
  # https://github.com/sebastiaanvisser/fclabels/issues/45
  # Doesn't compile with 9.8 at all
  # https://github.com/sebastiaanvisser/fclabels/issues/46
  fclabels =
    if lib.versionOlder self.ghc.version "9.8" then
      dontCheck super.fclabels
    else
      dontDistribute (markBroken super.fclabels);

  # Bounds on base are too strict.
  # https://github.com/phadej/regex-applicative-text/issues/13
  regex-applicative-text = doJailbreak super.regex-applicative-text;

  # Tests require a Kafka broker running locally
  haskakafka = dontCheck super.haskakafka;

  bindings-levmar = addExtraLibrary pkgs.blas super.bindings-levmar;

  # Requires wrapQtAppsHook
  qtah-cpp-qt5 = overrideCabal (drv: {
    buildDepends = [ pkgs.qt5.wrapQtAppsHook ];
  }) super.qtah-cpp-qt5;

  # The Haddock phase fails for one reason or another.
  deepseq-magic = dontHaddock super.deepseq-magic;
  feldspar-signal = dontHaddock super.feldspar-signal; # https://github.com/markus-git/feldspar-signal/issues/1
  hoodle-core = dontHaddock super.hoodle-core;
  hsc3-db = dontHaddock super.hsc3-db;

  # Fix build with time >= 1.10 while retaining compat with time < 1.9
  mbox = appendPatch ./patches/mbox-time-1.10.patch (
    overrideCabal {
      editedCabalFile = null;
      revision = null;
    } super.mbox
  );

  # https://github.com/techtangents/ablist/issues/1
  ABList = dontCheck super.ABList;

  inline-c-cpp = overrideCabal (drv: {
    postPatch = (drv.postPatch or "") + ''
      substituteInPlace inline-c-cpp.cabal --replace "-optc-std=c++11" ""
    '';
  }) super.inline-c-cpp;

  inline-java = addBuildDepend pkgs.jdk super.inline-java;

  # Too strict upper bound on unicode-transforms
  # <https://gitlab.com/ngua/ipa-hs/-/issues/1>
  ipa = doJailbreak super.ipa;

  # Upstream notified by e-mail.
  permutation = dontCheck super.permutation;

  # https://github.com/jputcu/serialport/issues/25
  serialport = dontCheck super.serialport;

  # Test suite depends on source code being available
  simple-affine-space = dontCheck super.simple-affine-space;

  # Fails no apparent reason. Upstream has been notified by e-mail.
  assertions = dontCheck super.assertions;

  # These packages try to execute non-existent external programs.
  cmaes = dontCheck super.cmaes; # http://hydra.cryp.to/build/498725/log/raw
  dbmigrations = dontCheck super.dbmigrations;
  filestore = dontCheck super.filestore;
  graceful = dontCheck super.graceful;
  ide-backend = dontCheck super.ide-backend;
  marquise = dontCheck super.marquise; # https://github.com/anchor/marquise/issues/69
  memcached-binary = dontCheck super.memcached-binary;
  msgpack-rpc = dontCheck super.msgpack-rpc;
  persistent-zookeeper = dontCheck super.persistent-zookeeper;
  pocket-dns = dontCheck super.pocket-dns;
  squeal-postgresql = dontCheck super.squeal-postgresql;
  postgrest-ws = dontCheck super.postgrest-ws;
  snowball = dontCheck super.snowball;
  sophia = dontCheck super.sophia;
  test-sandbox = dontCheck super.test-sandbox;
  texrunner = dontCheck super.texrunner;
  wai-middleware-hmac = dontCheck super.wai-middleware-hmac;
  xkbcommon = dontCheck super.xkbcommon;
  xmlgen = dontCheck super.xmlgen;
  HerbiePlugin = dontCheck super.HerbiePlugin;
  wai-cors = dontCheck super.wai-cors;

  # Apply patch fixing an incorrect QuickCheck property which occasionally causes false negatives
  # https://github.com/Philonous/xml-picklers/issues/5
  xml-picklers = appendPatch (pkgs.fetchpatch {
    name = "xml-picklers-fix-prop-xp-attribute.patch";
    url = "https://github.com/Philonous/xml-picklers/commit/887e5416b5e61c589cadf775d82013eb87751ea2.patch";
    sha256 = "sha256-EAyTVkAqCvJ0lRD0+q/htzBJ8iD5qP47j5i2fKhRrlw=";
  }) super.xml-picklers;

  # 2024-05-18: Upstream tests against a different pandoc version
  pandoc-crossref = dontCheck super.pandoc-crossref;

  # 2022-01-29: Tests require package to be in ghc-db.
  aeson-schemas = dontCheck super.aeson-schemas;

  matterhorn = doJailbreak super.matterhorn;

  # Too strict bounds on transformers and resourcet
  # https://github.com/alphaHeavy/lzma-conduit/issues/23
  lzma-conduit = doJailbreak super.lzma-conduit;

  # doctest suite needs adjustment with GHC 9.12
  xml-conduit = appendPatch (pkgs.fetchpatch {
    name = "xml-conduit-ghc-9.12.patch";
    url = "https://github.com/snoyberg/xml/commit/73ce67029c61decaa6525536377a15581325fd9e.patch";
    sha256 = "1gvdhwz7f6rw28xqm82h1kx2kwbdvigipfcb0y66520lvd544sm6";
    stripLen = 1;
  }) super.xml-conduit;

  # 2020-06-05: HACK: does not pass own build suite - `dontCheck`
  # 2024-01-15: too strict bound on free < 5.2
  hnix = doJailbreak (
    dontCheck (
      super.hnix.override {
        # 2023-12-11: Needs older core due to remote
        hnix-store-core = self.hnix-store-core_0_6_1_0;
      }
    )
  );

  # Too strict bounds on algebraic-graphs
  # https://github.com/haskell-nix/hnix-store/issues/180
  hnix-store-core_0_6_1_0 = doJailbreak super.hnix-store-core_0_6_1_0;

  # 2023-12-11: Needs older core
  hnix-store-remote = super.hnix-store-remote.override {
    hnix-store-core = self.hnix-store-core_0_6_1_0;
  };

  # Fails for non-obvious reasons while attempting to use doctest.
  focuslist = dontCheck super.focuslist;
  search = dontCheck super.search;

  # https://github.com/ekmett/structures/issues/3
  structures = dontCheck super.structures;

  # Disable test suites to fix the build.
  acme-year = dontCheck super.acme-year; # http://hydra.cryp.to/build/497858/log/raw
  aeson-lens = dontCheck super.aeson-lens; # http://hydra.cryp.to/build/496769/log/raw
  aeson-schema = dontCheck super.aeson-schema; # https://github.com/timjb/aeson-schema/issues/9
  angel = dontCheck super.angel;
  apache-md5 = dontCheck super.apache-md5; # http://hydra.cryp.to/build/498709/nixlog/1/raw
  app-settings = dontCheck super.app-settings; # http://hydra.cryp.to/build/497327/log/raw
  aws-kinesis = dontCheck super.aws-kinesis; # needs aws credentials for testing
  binary-protocol = dontCheck super.binary-protocol; # http://hydra.cryp.to/build/499749/log/raw
  binary-search = dontCheck super.binary-search;
  bloodhound = dontCheck super.bloodhound; # https://github.com/plow-technologies/quickcheck-arbitrary-template/issues/10
  buildwrapper = dontCheck super.buildwrapper;
  burst-detection = dontCheck super.burst-detection; # http://hydra.cryp.to/build/496948/log/raw
  cabal-meta = dontCheck super.cabal-meta; # http://hydra.cryp.to/build/497892/log/raw
  camfort = dontCheck super.camfort;
  cjk = dontCheck super.cjk;
  CLI = dontCheck super.CLI; # Upstream has no issue tracker.
  command-qq = dontCheck super.command-qq; # http://hydra.cryp.to/build/499042/log/raw
  conduit-connection = dontCheck super.conduit-connection;
  craftwerk = dontCheck super.craftwerk;
  crc = dontCheck super.crc; # https://github.com/MichaelXavier/crc/issues/2
  damnpacket = dontCheck super.damnpacket; # http://hydra.cryp.to/build/496923/log
  Deadpan-DDP = dontCheck super.Deadpan-DDP; # http://hydra.cryp.to/build/496418/log/raw
  DigitalOcean = dontCheck super.DigitalOcean;
  directory-layout = dontCheck super.directory-layout;
  dom-selector = dontCheck super.dom-selector; # http://hydra.cryp.to/build/497670/log/raw
  dotenv = dontCheck super.dotenv; # Tests fail because of missing test file on version 0.8.0.2 fixed on version 0.8.0.4
  dotfs = dontCheck super.dotfs; # http://hydra.cryp.to/build/498599/log/raw
  DRBG = dontCheck super.DRBG; # http://hydra.cryp.to/build/498245/nixlog/1/raw
  ed25519 = dontCheck super.ed25519;
  etcd = dontCheck super.etcd;
  fb = dontCheck super.fb; # needs credentials for Facebook
  fptest = dontCheck super.fptest; # http://hydra.cryp.to/build/499124/log/raw
  friday-juicypixels = dontCheck super.friday-juicypixels; # tarball missing test/rgba8.png
  ghc-events-parallel = dontCheck super.ghc-events-parallel; # http://hydra.cryp.to/build/496828/log/raw
  ghc-imported-from = dontCheck super.ghc-imported-from;
  ghc-parmake = dontCheck super.ghc-parmake;
  git-vogue = dontCheck super.git-vogue;
  github-rest = dontCheck super.github-rest; # test suite needs the network
  gitlib-cmdline = dontCheck super.gitlib-cmdline;
  GLFW-b = dontCheck super.GLFW-b; # https://github.com/bsl/GLFW-b/issues/50
  hackport = dontCheck super.hackport;
  hadoop-formats = dontCheck super.hadoop-formats;
  hashed-storage = dontCheck super.hashed-storage;
  hashring = dontCheck super.hashring;
  haxl = dontCheck super.haxl; # non-deterministic failure https://github.com/facebook/Haxl/issues/85
  haxl-facebook = dontCheck super.haxl-facebook; # needs facebook credentials for testing
  hdbi-postgresql = dontCheck super.hdbi-postgresql;
  hedis = dontCheck super.hedis;
  hedis-pile = dontCheck super.hedis-pile;
  hedis-tags = dontCheck super.hedis-tags;
  hgdbmi = dontCheck super.hgdbmi;
  hi = dontCheck super.hi;
  hierarchical-clustering = dontCheck super.hierarchical-clustering;
  hlibgit2 = disableHardening [ "format" ] super.hlibgit2;
  hmatrix-tests = dontCheck super.hmatrix-tests;
  hquery = dontCheck super.hquery;
  hs2048 = dontCheck super.hs2048;
  hsbencher = dontCheck super.hsbencher;
  # 2025-02-11: Too strict bounds on bytestring
  hsexif = doJailbreak (dontCheck super.hsexif);
  hspec-server = dontCheck super.hspec-server;
  HTF = overrideCabal (orig: {
    # The scripts in scripts/ are needed to build the test suite.
    preBuild = "patchShebangs --build scripts";
    # test suite doesn't compile with aeson >= 2.0
    # https://github.com/skogsbaer/HTF/issues/114
    doCheck = false;
  }) super.HTF;
  htsn = dontCheck super.htsn;
  htsn-import = dontCheck super.htsn-import;
  http-link-header = dontCheck super.http-link-header; # non deterministic failure https://hydra.nixos.org/build/75041105
  influxdb = dontCheck super.influxdb;
  integer-roots = dontCheck super.integer-roots; # requires an old version of smallcheck, will be fixed in > 1.0
  itanium-abi = dontCheck super.itanium-abi;
  katt = dontCheck super.katt;
  language-slice = dontCheck super.language-slice;

  # Bogus lower bound on data-default-class added via Hackage revision
  # https://github.com/mrkkrp/req/pull/180#issuecomment-2628201485
  req = overrideCabal {
    revision = null;
    editedCabalFile = null;
  } super.req;

  # Group of libraries by same upstream maintainer for interacting with
  # Telegram messenger. Bit-rotted a bit since 2020.
  tdlib = appendPatch (fetchpatch {
    # https://github.com/poscat0x04/tdlib/pull/3
    url = "https://github.com/poscat0x04/tdlib/commit/8eb9ecbc98c65a715469fdb8b67793ab375eda31.patch";
    hash = "sha256-vEI7fTsiafNGBBl4VUXVCClW6xKLi+iK53fjcubgkpc=";
  }) (doJailbreak super.tdlib);
  tdlib-types = doJailbreak super.tdlib-types;
  tdlib-gen = doJailbreak super.tdlib-gen;
  # https://github.com/poscat0x04/language-tl/pull/1
  language-tl = doJailbreak super.language-tl;

  ldap-client = dontCheck super.ldap-client;
  lensref = dontCheck super.lensref;
  lvmrun = disableHardening [ "format" ] (dontCheck super.lvmrun);
  matplotlib = dontCheck super.matplotlib;
  milena = dontCheck super.milena;
  modular-arithmetic = dontCheck super.modular-arithmetic; # tests require a very old Glob (0.7.*)
  nats-queue = dontCheck super.nats-queue;
  network-dbus = dontCheck super.network-dbus;
  notcpp = dontCheck super.notcpp;
  ntp-control = dontCheck super.ntp-control;
  odpic-raw = dontCheck super.odpic-raw; # needs a running oracle database server
  opaleye = dontCheck super.opaleye;
  openpgp = dontCheck super.openpgp;
  optional = dontCheck super.optional;
  orgmode-parse = dontCheck super.orgmode-parse;
  os-release = dontCheck super.os-release;
  parameterized = dontCheck super.parameterized; # https://github.com/louispan/parameterized/issues/2
  persistent-redis = dontCheck super.persistent-redis;
  pipes-extra = dontCheck super.pipes-extra;
  posix-pty = dontCheck super.posix-pty; # https://github.com/merijn/posix-pty/issues/12
  postgresql-binary = dontCheck super.postgresql-binary; # needs a running postgresql server
  powerdns = dontCheck super.powerdns; # Tests require networking and external services
  process-streaming = dontCheck super.process-streaming;
  punycode = dontCheck super.punycode;
  pwstore-cli = dontCheck super.pwstore-cli;
  quantities = dontCheck super.quantities;
  redis-io = dontCheck super.redis-io;
  rethinkdb = dontCheck super.rethinkdb;
  Rlang-QQ = dontCheck super.Rlang-QQ;
  sai-shape-syb = dontCheck super.sai-shape-syb;
  scp-streams = dontCheck super.scp-streams;
  sdl2 = dontCheck super.sdl2; # the test suite needs an x server
  separated = dontCheck super.separated;
  shadowsocks = dontCheck super.shadowsocks;
  shake-language-c = dontCheck super.shake-language-c;
  sourcemap = dontCheck super.sourcemap;
  static-resources = dontCheck super.static-resources;
  svndump = dontCheck super.svndump;
  tar = dontCheck super.tar; # https://hydra.nixos.org/build/25088435/nixlog/2 (fails only on 32-bit)
  thumbnail-plus = dontCheck super.thumbnail-plus;
  tickle = dontCheck super.tickle;
  tpdb = dontCheck super.tpdb;
  translatable-intset = dontCheck super.translatable-intset;
  ua-parser = dontCheck super.ua-parser;
  unagi-chan = dontCheck super.unagi-chan;
  WebBits = dontCheck super.WebBits; # http://hydra.cryp.to/build/499604/log/raw
  webdriver-angular = dontCheck super.webdriver-angular;
  xsd = dontCheck super.xsd;

  # Allow template-haskell 2.22
  # https://github.com/well-typed/ixset-typed/pull/23
  ixset-typed =
    appendPatches
      [
        (fetchpatch {
          name = "ixset-typed-template-haskell-2.21.patch";
          url = "https://github.com/well-typed/ixset-typed/commit/085cccbaa845bff4255028ed5ff71402e98a953a.patch";
          sha256 = "1cz30dmby3ff3zcnyz7d2xsqls7zxmzig7bgzy2gfa24s3sa32jg";
        })
        (fetchpatch {
          name = "ixset-typed-template-haskell-2.22.patch";
          url = "https://github.com/well-typed/ixset-typed/commit/0d699386eab5c4f6aa53e4de41defb460acbbd99.patch";
          sha256 = "04lbfvaww05czhnld674c9hm952f94xpicf08hby8xpksfj7rs41";
        })
      ]
      (
        overrideCabal {
          editedCabalFile = null;
          revision = null;
        } super.ixset-typed
      );

  # https://github.com/eli-frey/cmdtheline/issues/28
  cmdtheline = dontCheck super.cmdtheline;

  # https://github.com/bos/snappy/issues/1
  # https://github.com/bos/snappy/pull/10
  snappy = dontCheck super.snappy;

  # https://github.com/vincenthz/hs-crypto-pubkey/issues/20
  crypto-pubkey = dontCheck super.crypto-pubkey;

  # https://github.com/joeyadams/haskell-stm-delay/issues/3
  stm-delay = dontCheck super.stm-delay;

  # Skip test that checks a race condition between stm and stm-queue
  stm-queue = overrideCabal (drv: {
    testFlags = drv.testFlags or [ ] ++ [
      "--skip"
      "/Data.Queue/behaves faster than TQueue in its worst case/"
    ];
  }) super.stm-queue;

  # https://github.com/pixbi/duplo/issues/25
  duplo = doJailbreak super.duplo;

  # https://github.com/evanrinehart/mikmod/issues/1
  mikmod = addExtraLibrary pkgs.libmikmod super.mikmod;

  # Missing module.
  rematch = dontCheck super.rematch; # https://github.com/tcrayford/rematch/issues/5
  rematch-text = dontCheck super.rematch-text; # https://github.com/tcrayford/rematch/issues/6

  # Package exists only to be example of documentation, yet it has restrictive
  # "base" dependency.
  haddock-cheatsheet = doJailbreak super.haddock-cheatsheet;

  # no haddock since this is an umbrella package.
  cloud-haskell = dontHaddock super.cloud-haskell;

  # This packages compiles 4+ hours on a fast machine. That's just unreasonable.
  CHXHtml = dontDistribute super.CHXHtml;

  # https://github.com/NixOS/nixpkgs/issues/6350
  paypal-adaptive-hoops = overrideCabal (drv: {
    testTargets = [ "local" ];
  }) super.paypal-adaptive-hoops;

  # Avoid "QuickCheck >=2.3 && <2.10" dependency we cannot fulfill in lts-11.x.
  test-framework = dontCheck super.test-framework;

  # Depends on broken test-framework-quickcheck.
  apiary = dontCheck super.apiary;
  apiary-authenticate = dontCheck super.apiary-authenticate;
  apiary-clientsession = dontCheck super.apiary-clientsession;
  apiary-cookie = dontCheck super.apiary-cookie;
  apiary-eventsource = dontCheck super.apiary-eventsource;
  apiary-logger = dontCheck super.apiary-logger;
  apiary-memcached = dontCheck super.apiary-memcached;
  apiary-mongoDB = dontCheck super.apiary-mongoDB;
  apiary-persistent = dontCheck super.apiary-persistent;
  apiary-purescript = dontCheck super.apiary-purescript;
  apiary-session = dontCheck super.apiary-session;
  apiary-websockets = dontCheck super.apiary-websockets;

  # https://github.com/junjihashimoto/test-sandbox-compose/issues/2
  test-sandbox-compose = dontCheck super.test-sandbox-compose;

  # Test suite won't compile against tasty-hunit 0.10.x.
  binary-parsers = dontCheck super.binary-parsers;

  # https://github.com/ndmitchell/shake/issues/804
  shake = dontCheck super.shake;

  # https://github.com/nushio3/doctest-prop/issues/1
  doctest-prop = dontCheck super.doctest-prop;

  # Missing file in source distribution:
  # - https://github.com/karun012/doctest-discover/issues/22
  # - https://github.com/karun012/doctest-discover/issues/23
  #
  # When these are fixed the following needs to be enabled again:
  #
  # # Depends on itself for testing
  # doctest-discover = addBuildTool super.doctest-discover
  #   (if pkgs.stdenv.buildPlatform != pkgs.stdenv.hostPlatform
  #    then self.buildHaskellPackages.doctest-discover
  #    else dontCheck super.doctest-discover);
  doctest-discover = dontCheck super.doctest-discover;

  # 2025-02-10: Too strict bounds on doctest < 0.22
  tasty-checklist = doJailbreak super.tasty-checklist;

  # 2025-02-10: Too strict bounds on hedgehog < 1.5
  tasty-sugar = doJailbreak super.tasty-sugar;

  # Known issue with nondeterministic test suite failure
  # https://github.com/nomeata/tasty-expected-failure/issues/21
  tasty-expected-failure = dontCheck super.tasty-expected-failure;

  # https://github.com/yaccz/saturnin/issues/3
  Saturnin = dontCheck super.Saturnin;

  # https://github.com/kkardzis/curlhs/issues/6
  curlhs = dontCheck super.curlhs;

  # curl 7.87.0 introduces a preprocessor typechecker of sorts which fails on
  # incorrect usages of curl_easy_getopt and similar functions. Presumably
  # because the wrappers in curlc.c don't use static values for the different
  # arguments to curl_easy_getinfo, it complains and needs to be disabled.
  # https://github.com/GaloisInc/curl/issues/28
  curl = appendConfigureFlags [
    "--ghc-option=-DCURL_DISABLE_TYPECHECK"
  ] super.curl;

  # https://github.com/alphaHeavy/lzma-enumerator/issues/3
  lzma-enumerator = dontCheck super.lzma-enumerator;

  # FPCO's fork of Cabal won't succeed its test suite.
  Cabal-ide-backend = dontCheck super.Cabal-ide-backend;

  # This package can't be built on non-Windows systems.
  Win32 = overrideCabal (drv: { broken = !pkgs.stdenv.hostPlatform.isCygwin; }) super.Win32;
  inline-c-win32 = dontDistribute super.inline-c-win32;
  Southpaw = dontDistribute super.Southpaw;

  # https://ghc.haskell.org/trac/ghc/ticket/9825
  vimus = overrideCabal (drv: {
    broken = pkgs.stdenv.hostPlatform.isLinux && pkgs.stdenv.hostPlatform.isi686;
  }) super.vimus;

  # https://github.com/kazu-yamamoto/logger/issues/42
  logger = dontCheck super.logger;

  # Byte-compile elisp code for Emacs.
  ghc-mod = overrideCabal (drv: {
    preCheck = "export HOME=$TMPDIR";
    testToolDepends = drv.testToolDepends or [ ] ++ [ self.cabal-install ];
    doCheck = false; # https://github.com/kazu-yamamoto/ghc-mod/issues/335
    executableToolDepends = drv.executableToolDepends or [ ] ++ [ pkgs.buildPackages.emacs ];
    postInstall = ''
      local lispdir=( "$data/share/${self.ghc.targetPrefix}${self.ghc.haskellCompilerName}/*/${drv.pname}-${drv.version}/elisp" )
      make -C $lispdir
      mkdir -p $data/share/emacs/site-lisp
      ln -s "$lispdir/"*.el{,c} $data/share/emacs/site-lisp/
    '';
  }) super.ghc-mod;

  # 2022-03-19: Testsuite is failing: https://github.com/puffnfresh/haskell-jwt/issues/2
  jwt = dontCheck super.jwt;

  # Build Selda with the latest git version.
  # See https://github.com/valderman/selda/issues/187
  inherit
    (
      let
        mkSeldaPackage =
          name:
          overrideCabal (drv: {
            version = "2024-05-05-unstable";
            src =
              pkgs.fetchFromGitHub {
                owner = "valderman";
                repo = "selda";
                rev = "50c3ba5c5da72bb758a4112363ba2fe1c0e968ea";
                hash = "sha256-LEAJsSsDL0mmVHntnI16fH8m5DmePfcU0hFw9ErqTgQ=";
              }
              + "/${name}";
            # 2025-04-09: jailbreak to allow bytestring >= 0.12, text >= 2.1
            # Note: jailbreak ignores constraints under an if(flag)
            postPatch = ''
              check_sed() {
                if ! test -s "$1"; then
                  echo "sed: pattern '$2' doesn't match anything" >&2
                  exit 1
                fi
              }
              sed -i ${name}.cabal \
                -e 's/\(bytestring\) .*/\1/w c1' \
                -e 's/\(text\) .*/\1/w c2' \
                -e 's/\(aeson\) .*/\1/w c3'
              check_sed c1 'bytestring .*'
              check_sed c2 'text .*'
              ${lib.optionalString (name == "selda-json") "check_sed c3 'aeson .*'"}
            '';
          }) super.${name};
      in
      lib.genAttrs [ "selda" "selda-sqlite" "selda-json" ] mkSeldaPackage
    )
    selda
    selda-sqlite
    selda-json
    ;

  # 2024-03-10: Getting the test suite to run requires a correctly crafted GHC_ENVIRONMENT variable.
  graphql-client = dontCheck super.graphql-client;

  # Build the latest git version instead of the official release. This isn't
  # ideal, but Chris doesn't seem to make official releases any more.
  structured-haskell-mode = overrideCabal (drv: {
    src = pkgs.fetchFromGitHub {
      owner = "projectional-haskell";
      repo = "structured-haskell-mode";
      rev = "7f9df73f45d107017c18ce4835bbc190dfe6782e";
      sha256 = "1jcc30048j369jgsbbmkb63whs4wb37bq21jrm3r6ry22izndsqa";
    };
    version = "20170205-git";
    editedCabalFile = null;
    # Make elisp files available at a location where people expect it. We
    # cannot easily byte-compile these files, unfortunately, because they
    # depend on a new version of haskell-mode that we don't have yet.
    postInstall = ''
      local lispdir=( "$data/share/${self.ghc.targetPrefix}${self.ghc.haskellCompilerName}/"*"/${drv.pname}-"*"/elisp" )
      mkdir -p $data/share/emacs
      ln -s $lispdir $data/share/emacs/site-lisp
    '';
  }) super.structured-haskell-mode;

  # Make elisp files available at a location where people expect it.
  hindent = (
    overrideCabal (drv: {
      # We cannot easily byte-compile these files, unfortunately, because they
      # depend on a new version of haskell-mode that we don't have yet.
      postInstall = ''
        local lispdir=( "$data/share/${self.ghc.targetPrefix}${self.ghc.haskellCompilerName}/"*"/${drv.pname}-"*"/elisp" )
        mkdir -p $data/share/emacs
        ln -s $lispdir $data/share/emacs/site-lisp
      '';
    }) super.hindent
  );

  # https://github.com/basvandijk/concurrent-extra/issues/12
  concurrent-extra = dontCheck super.concurrent-extra;

  # https://github.com/pxqr/base32-bytestring/issues/4
  base32-bytestring = dontCheck super.base32-bytestring;

  # Too strict bounds on bytestring (<0.12) on the test suite
  # https://github.com/emilypi/Base32/issues/24
  base32 = doJailbreak super.base32;

  # Djinn's last release was 2014, incompatible with Semigroup-Monoid Proposal
  # https://github.com/augustss/djinn/pull/8
  djinn = overrideSrc {
    version = "unstable-2023-11-20";
    src = pkgs.fetchFromGitHub {
      owner = "augustss";
      repo = "djinn";
      rev = "69b3fbad9f42f0b1b2c49977976b8588c967d76e";
      hash = "sha256-ibxn6DXk4pqsOsWhi8KcrlH/THnuMWvIu5ENOn3H3So=";
    };
  } super.djinn;

  # https://github.com/Philonous/hs-stun/pull/1
  # Remove if a version > 0.1.0.1 ever gets released.
  stunclient = overrideCabal (drv: {
    postPatch = (drv.postPatch or "") + ''
      substituteInPlace source/Network/Stun/MappedAddress.hs --replace "import Network.Endian" ""
    '';
  }) super.stunclient;

  d-bus =
    let
      # The latest release on hackage is missing necessary patches for recent compilers
      # https://github.com/Philonous/d-bus/issues/24
      newer = overrideSrc {
        version = "unstable-2021-01-08";
        src = pkgs.fetchFromGitHub {
          owner = "Philonous";
          repo = "d-bus";
          rev = "fb8a948a3b9d51db618454328dbe18fb1f313c70";
          hash = "sha256-R7/+okb6t9DAkPVUV70QdYJW8vRcvBdz4zKJT13jb3A=";
        };
      } super.d-bus;
      # Add now required extension on recent compilers.
      # https://github.com/Philonous/d-bus/pull/23
    in
    appendPatch (fetchpatch {
      url = "https://github.com/Philonous/d-bus/commit/e5f37900a3a301c41d98bdaa134754894c705681.patch";
      sha256 = "6rQ7H9t483sJe1x95yLPAZ0BKTaRjgqQvvrQv7HkJRE=";
    }) newer;

  # * The standard libraries are compiled separately.
  # * We need a few patches from master to fix compilation with
  #   updated dependencies which can be
  #   removed when the next idris release comes around.
  idris = lib.pipe super.idris [
    dontCheck
    doJailbreak
    (appendPatch (fetchpatch {
      name = "idris-bumps.patch";
      url = "https://github.com/idris-lang/Idris-dev/compare/c99bc9e4af4ea32d2172f873152b76122ee4ee14...cf78f0fb337d50f4f0dba235b6bbe67030f1ff47.patch";
      hash = "sha256-RCMIRHIAK1PCm4B7v+5gXNd2buHXIqyAxei4bU8+eCk=";
    }))
    (self.generateOptparseApplicativeCompletions [ "idris" ])
  ];

  # https://hydra.nixos.org/build/42769611/nixlog/1/raw
  # note: the library is unmaintained, no upstream issue
  dataenc = doJailbreak super.dataenc;

  # Test suite occasionally runs for 1+ days on Hydra.
  distributed-process-tests = dontCheck super.distributed-process-tests;

  # https://github.com/mulby/diff-parse/issues/9
  diff-parse = doJailbreak super.diff-parse;

  # No upstream issue tracker
  hspec-expectations-pretty-diff = dontCheck super.hspec-expectations-pretty-diff;

  # The tests spuriously fail
  libmpd = dontCheck super.libmpd;

  # https://github.com/xu-hao/namespace/issues/1
  namespace = doJailbreak super.namespace;

  # https://github.com/danidiaz/streaming-eversion/issues/1
  streaming-eversion = dontCheck super.streaming-eversion;

  # https://github.com/danidiaz/tailfile-hinotify/issues/2
  tailfile-hinotify = doJailbreak (dontCheck super.tailfile-hinotify);

  # Test suite fails: https://github.com/lymar/hastache/issues/46.
  # Don't install internal mkReadme tool.
  hastache = overrideCabal (drv: {
    doCheck = false;
    postInstall = "rm $out/bin/mkReadme && rmdir $out/bin";
  }) super.hastache;

  # 2025-02-10: Too strict bounds on text < 2.1
  digestive-functors-blaze = doJailbreak super.digestive-functors-blaze;

  # Wrap the generated binaries to include their run-time dependencies in
  # $PATH. Also, cryptol needs a version of sbl that's newer than what we have
  # in LTS-13.x.
  cryptol = overrideCabal (drv: {
    buildTools = drv.buildTools or [ ] ++ [ pkgs.buildPackages.makeWrapper ];
    postInstall = drv.postInstall or "" + ''
      for b in $out/bin/cryptol $out/bin/cryptol-html; do
        wrapProgram $b --prefix 'PATH' ':' "${lib.getBin pkgs.z3}/bin"
      done
    '';
  }) super.cryptol;

  # Z3 removed aliases for boolean types in 4.12
  inherit
    (
      let
        fixZ3 = appendConfigureFlags [
          "--hsc2hs-option=-DZ3_Bool=bool"
          "--hsc2hs-option=-DZ3_TRUE=true"
          "--hsc2hs-option=-DZ3_FALSE=false"
        ];
      in
      {
        z3 = fixZ3 super.z3;
        hz3 = fixZ3 super.hz3;
      }
    )
    z3
    hz3
    ;

  # test suite requires git and does a bunch of git operations
  restless-git = dontCheck super.restless-git;

  # Work around https://github.com/haskell/c2hs/issues/192.
  c2hs = dontCheck super.c2hs;

  # Needs pginit to function and pgrep to verify.
  tmp-postgres = overrideCabal (drv: {
    # Flaky tests: https://github.com/jfischoff/tmp-postgres/issues/274
    doCheck = false;

    preCheck = ''
      export HOME="$TMPDIR"
    ''
    + (drv.preCheck or "");
    libraryToolDepends = drv.libraryToolDepends or [ ] ++ [ pkgs.buildPackages.postgresql ];
    testToolDepends = drv.testToolDepends or [ ] ++ [ pkgs.procps ];
  }) super.tmp-postgres;

  # Needs QuickCheck <2.10, which we don't have.
  edit-distance = doJailbreak super.edit-distance;

  # With ghc-8.2.x haddock would time out for unknown reason
  # See https://github.com/haskell/haddock/issues/679
  language-puppet = dontHaddock super.language-puppet;

  # https://github.com/alphaHeavy/protobuf/issues/34
  protobuf = dontCheck super.protobuf;

  # The test suite does not know how to find the 'alex' binary.
  alex = overrideCabal (drv: {
    testSystemDepends = (drv.testSystemDepends or [ ]) ++ [ pkgs.which ];
    preCheck = ''export PATH="$PWD/dist/build/alex:$PATH"'';
  }) super.alex;

  # Compiles some C or C++ source which requires these headers
  VulkanMemoryAllocator = addExtraLibrary pkgs.vulkan-headers super.VulkanMemoryAllocator;
  vulkan-utils = addExtraLibrary pkgs.vulkan-headers super.vulkan-utils;

  # Generate cli completions for dhall.
  dhall = self.generateOptparseApplicativeCompletions [ "dhall" ] super.dhall;
  # 2025-01-27: allow aeson >= 2.2, 9.8 versions of text and bytestring
  dhall-json = self.generateOptparseApplicativeCompletions [ "dhall-to-json" "dhall-to-yaml" ] (
    doJailbreak super.dhall-json
  );
  dhall-nix = self.generateOptparseApplicativeCompletions [ "dhall-to-nix" ] super.dhall-nix;
  # 2025-02-10: jailbreak due to aeson < 2.2, hnix < 0.17, transformers < 0.6, turtle < 1.6
  dhall-nixpkgs = self.generateOptparseApplicativeCompletions [ "dhall-to-nixpkgs" ] (
    doJailbreak super.dhall-nixpkgs
  );
  dhall-yaml = self.generateOptparseApplicativeCompletions [ "dhall-to-yaml-ng" "yaml-to-dhall" ] (
    doJailbreak super.dhall-yaml
  ); # bytestring <0.12, text<2.1
  # 2025-02-14: see also https://github.com/dhall-lang/dhall-haskell/issues/2638
  dhall-bash = doJailbreak super.dhall-bash; # bytestring <0.12, text <2.1

  # musl fixes
  # dontCheck: use of non-standard strptime "%s" which musl doesn't support; only used in test
  unix-time = if pkgs.stdenv.hostPlatform.isMusl then dontCheck super.unix-time else super.unix-time;

  # Workaround for https://github.com/sol/hpack/issues/528
  # The hpack test suite can't deal with the CRLF line endings hackage revisions insert
  hpack = overrideCabal (drv: {
    postPatch = drv.postPatch or "" + ''
      "${lib.getBin pkgs.buildPackages.dos2unix}/bin/dos2unix" *.cabal
    '';
  }) super.hpack;

  # hslua has tests that break when using musl.
  # https://github.com/hslua/hslua/issues/106
  hslua-core =
    if pkgs.stdenv.hostPlatform.isMusl then dontCheck super.hslua-core else super.hslua-core;

  # The test suite runs for 20+ minutes on a very fast machine, which feels kinda disproportionate.
  prettyprinter = dontCheck super.prettyprinter;

  # Fix with Cabal 2.2, https://github.com/guillaume-nargeot/hpc-coveralls/pull/73
  hpc-coveralls = appendPatch (fetchpatch {
    url = "https://github.com/guillaume-nargeot/hpc-coveralls/pull/73/commits/344217f513b7adfb9037f73026f5d928be98d07f.patch";
    sha256 = "056rk58v9h114mjx62f41x971xn9p3nhsazcf9zrcyxh1ymrdm8j";
  }) super.hpc-coveralls;

  # sexpr is old, broken and has no issue-tracker. Let's fix it the best we can.
  sexpr = appendPatch ./patches/sexpr-0.2.1.patch (
    overrideCabal (drv: {
      isExecutable = false;
      libraryHaskellDepends = drv.libraryHaskellDepends ++ [ self.QuickCheck ];
    }) super.sexpr
  );

  # https://github.com/haskell/hoopl/issues/50
  hoopl = dontCheck super.hoopl;

  # TODO(Profpatsch): factor out local nix store setup from
  # lib/tests/release.nix and use that for the tests of libnix
  # libnix = overrideCabal (old: {
  #   testToolDepends = old.testToolDepends or [] ++ [ pkgs.nix ];
  # }) super.libnix;
  libnix = dontCheck super.libnix;

  # dontCheck: The test suite tries to mess with ALSA, which doesn't work in the build sandbox.
  xmobar = dontCheck super.xmobar;

  # 2025-02-10: Too strict bounds on aeson < 1.5
  json-alt = doJailbreak super.json-alt;

  # https://github.com/mgajda/json-autotype/issues/25
  json-autotype = dontCheck super.json-autotype;

  postgresql-simple-migration = overrideCabal (drv: {
    preCheck = ''
      PGUSER=test
      PGDATABASE=test
    '';
    testToolDepends = drv.testToolDepends or [ ] ++ [
      pkgs.postgresql
      pkgs.postgresqlTestHook
    ];
  }) (doJailbreak super.postgresql-simple-migration);

  postgresql-simple = addTestToolDepends [
    pkgs.postgresql
    pkgs.postgresqlTestHook
  ] super.postgresql-simple;

  beam-postgres = lib.pipe super.beam-postgres [
    # Requires pg_ctl command during tests
    (addTestToolDepends [ pkgs.postgresql ])
    (dontCheckIf (!pkgs.postgresql.doInstallCheck || !self.testcontainers.doCheck))
  ];

  users-postgresql-simple = addTestToolDepends [
    pkgs.postgresql
    pkgs.postgresqlTestHook
  ] super.users-postgresql-simple;

  gargoyle-postgresql-nix = addBuildTool [ pkgs.postgresql ] super.gargoyle-postgresql-nix;

  # PortMidi needs an environment variable to have ALSA find its plugins:
  # https://github.com/NixOS/nixpkgs/issues/6860
  PortMidi = overrideCabal (drv: {
    patches = (drv.patches or [ ]) ++ [ ./patches/portmidi-alsa-plugins.patch ];
    postPatch = (drv.postPatch or "") + ''
      substituteInPlace portmidi/pm_linux/pmlinuxalsa.c \
        --replace @alsa_plugin_dir@ "${pkgs.alsa-plugins}/lib/alsa-lib"
    '';
  }) super.PortMidi;

  scat = overrideCabal (drv: {
    patches = [
      # Fix build with base >= 4.11 (https://github.com/redelmann/scat/pull/6)
      (fetchpatch {
        url = "https://github.com/redelmann/scat/commit/429f22944b7634b8789cb3805292bcc2b23e3e9f.diff";
        hash = "sha256-FLr1KfBaSYzI6MiZIBY1CkgAb5sThvvgjrSAN8EV0h4=";
      })
      # Fix build with vector >= 0.13, mtl >= 2.3 (https://github.com/redelmann/scat/pull/8)
      (fetchpatch {
        url = "https://github.com/redelmann/scat/compare/e8e064f7e6a152fe25a6ccd743573a16974239d0..c6a3636548d628f32d8edc73a333188ce24141a7.patch";
        hash = "sha256-BU4MUn/TnZHpZBlX1vDHE7QZva5yhlLTb8zwpx7UScI";
      })
    ];
  }) super.scat;

  # Fix build with attr-2.4.48 (see #53716)
  xattr = appendPatch ./patches/xattr-fix-build.patch super.xattr;

  esqueleto =
    overrideCabal
      (drv: {
        postPatch = drv.postPatch or "" + ''
          # patch out TCP usage: https://nixos.org/manual/nixpkgs/stable/#sec-postgresqlTestHook-tcp
          sed -i test/PostgreSQL/Test.hs \
            -e s^host=localhost^^
        '';
        # Match the test suite defaults (or hardcoded values?)
        preCheck = drv.preCheck or "" + ''
          PGUSER=esqutest
          PGDATABASE=esqutest
        '';
        testFlags = drv.testFlags or [ ] ++ [
          # We don't have a MySQL test hook yet
          "--skip=/Esqueleto/MySQL"
        ];
        testToolDepends = drv.testToolDepends or [ ] ++ [
          pkgs.postgresql
          pkgs.postgresqlTestHook
        ];
      })
      # https://github.com/NixOS/nixpkgs/issues/198495
      (dontCheckIf (pkgs.postgresqlTestHook.meta.broken) super.esqueleto);

  # Requires API keys to run tests
  algolia = dontCheck super.algolia;
  openai-hs = dontCheck super.openai-hs;

  # antiope-s3's latest stackage version has a hspec < 2.6 requirement, but
  # hspec which isn't in stackage is already past that
  antiope-s3 = doJailbreak super.antiope-s3;

  # Has tasty < 1.2 requirement, but works just fine with 1.2
  temporary-resourcet = doJailbreak super.temporary-resourcet;

  # Test suite doesn't work with current QuickCheck
  # https://github.com/pruvisto/heap/issues/11
  heap = dontCheck super.heap;

  # Test suite won't link for no apparent reason.
  constraints-deriving = dontCheck super.constraints-deriving;

  # https://github.com/erikd/hjsmin/issues/32
  hjsmin = dontCheck super.hjsmin;

  # Remove for hail > 0.2.0.0
  hail = doJailbreak super.hail;

  # https://github.com/kazu-yamamoto/dns/issues/150
  dns = dontCheck super.dns;

  # https://github.com/haskell-servant/servant-ekg/issues/15
  servant-ekg = doJailbreak super.servant-ekg;

  # it wants to build a statically linked binary by default
  hledger-flow = overrideCabal (drv: {
    postPatch = (drv.postPatch or "") + ''
      substituteInPlace hledger-flow.cabal --replace "-static" ""
    '';
  }) super.hledger-flow;

  # Chart-tests needs and compiles some modules from Chart itself
  Chart-tests = overrideCabal (old: {
    # 2025-02-13: Too strict bounds on lens < 5.3 and vector < 0.13
    jailbreak = true;
    preCheck = old.preCheck or "" + ''
      tar --one-top-level=../chart --strip-components=1 -xf ${self.Chart.src}
    '';
  }) (addExtraLibrary self.QuickCheck super.Chart-tests);

  # This breaks because of version bounds, but compiles and runs fine.
  # Last commit is 5 years ago, so we likely won't get upstream fixed soon.
  # https://bitbucket.org/rvlm/hakyll-contrib-hyphenation/src/master/
  # Therefore we jailbreak it.
  hakyll-contrib-hyphenation = doJailbreak super.hakyll-contrib-hyphenation;

  # The test suite depends on an impure cabal-install installation in
  # $HOME, which we don't have in our build sandbox.
  cabal-install-parsers = dontCheck super.cabal-install-parsers;

  # Test suite requires database
  persistent-mysql = dontCheck super.persistent-mysql;
  persistent-postgresql =
    # TODO: move this override to configuration-nix.nix
    overrideCabal
      (drv: {
        postPatch = drv.postPath or "" + ''
          # patch out TCP usage: https://nixos.org/manual/nixpkgs/stable/#sec-postgresqlTestHook-tcp
          # NOTE: upstream host variable takes only two values...
          sed -i test/PgInit.hs \
            -e s^'host=" <> host <> "'^^
        '';
        preCheck = drv.preCheck or "" + ''
          PGDATABASE=test
          PGUSER=test
        '';
        testToolDepends = drv.testToolDepends or [ ] ++ [
          pkgs.postgresql
          pkgs.postgresqlTestHook
        ];
      })
      # https://github.com/NixOS/nixpkgs/issues/198495
      (dontCheckIf (pkgs.postgresqlTestHook.meta.broken) super.persistent-postgresql);

  # Needs matching lsp-types
  # Allow lens >= 5.3
  lsp_2_4_0_0 = doDistribute (
    doJailbreak (
      super.lsp_2_4_0_0.override {
        lsp-types = self.lsp-types_2_1_1_0;
      }
    )
  );

  # Needs matching lsp-types;
  # Lift bound on sorted-list <0.2.2
  lsp_2_1_0_0 = doDistribute (
    doJailbreak (
      super.lsp_2_1_0_0.override {
        lsp-types = self.lsp-types_2_1_1_0;
      }
    )
  );
  # Lift bound on lens <5.3
  lsp-types_2_1_1_0 = doDistribute (doJailbreak super.lsp-types_2_1_1_0);

  # 2025-03-03: dhall-lsp-server-1.1.4 requires lsp-2.1.0.0
  dhall-lsp-server = super.dhall-lsp-server.override {
    lsp = self.lsp_2_1_0_0;
  };

  # Tests disabled and broken override needed because of missing lib chrome-test-utils: https://github.com/reflex-frp/reflex-dom/issues/392
  reflex-dom-core = lib.pipe super.reflex-dom-core [
    doDistribute
    dontCheck
    unmarkBroken
  ];

  # https://github.com/ghcjs/jsaddle/issues/151
  jsaddle-webkit2gtk =
    overrideCabal
      (drv: {
        postPatch = drv.postPatch or "" + ''
          substituteInPlace jsaddle-webkit2gtk.cabal --replace-fail gi-gtk gi-gtk3
          substituteInPlace jsaddle-webkit2gtk.cabal --replace-fail gi-javascriptcore gi-javascriptcore4
        '';
      })
      (
        super.jsaddle-webkit2gtk.override {
          gi-gtk = self.gi-gtk3;
          gi-javascriptcore = self.gi-javascriptcore4;
        }
      );

  # 2020-06-24: Jailbreaking because of restrictive test dep bounds
  # Upstream issue: https://github.com/kowainik/trial/issues/62
  trial = doJailbreak super.trial;

  # 2024-03-19: Fix for mtl >= 2.3
  pattern-arrows = lib.pipe super.pattern-arrows [
    doJailbreak
    (appendPatches [ ./patches/pattern-arrows-add-fix-import.patch ])
  ];

  # 2024-03-19: Fix for mtl >= 2.3
  cheapskate = lib.pipe super.cheapskate [
    doJailbreak
    (appendPatches [ ./patches/cheapskate-mtl-2-3-support.patch ])
  ];

  # 2020-06-24: Tests are broken in hackage distribution.
  # See: https://github.com/robstewart57/rdf4h/issues/39
  rdf4h = dontCheck super.rdf4h;

  # Fixed upstream but not released to Hackage yet:
  # https://github.com/k0001/hs-libsodium/issues/2
  libsodium = overrideCabal (drv: {
    libraryToolDepends = (drv.libraryToolDepends or [ ]) ++ [ self.buildHaskellPackages.c2hs ];
  }) super.libsodium;

  svgcairo = overrideCabal (drv: {
    patches = drv.patches or [ ] ++ [
      # Remove when https://github.com/gtk2hs/svgcairo/pull/12 goes in.
      (fetchpatch {
        url = "https://github.com/gtk2hs/svgcairo/commit/348c60b99c284557a522baaf47db69322a0a8b67.patch";
        sha256 = "0akhq6klmykvqd5wsbdfnnl309f80ds19zgq06sh1mmggi54dnf3";
      })
      # Remove when https://github.com/gtk2hs/svgcairo/pull/13 goes in.
      (fetchpatch {
        url = "https://github.com/dalpd/svgcairo/commit/d1e0d7ae04c1edca83d5b782e464524cdda6ae85.patch";
        sha256 = "1pq9ld9z67zsxj8vqjf82qwckcp69lvvnrjb7wsyb5jc6jaj3q0a";
      })
    ];
    editedCabalFile = null;
    revision = null;
  }) super.svgcairo;

  # Too strict upper bound on tasty-hedgehog (<1.5)
  # https://github.com/typeclasses/ascii-predicates/pull/1
  ascii-predicates = doJailbreak super.ascii-predicates;
  ascii-numbers = doJailbreak super.ascii-numbers;

  # Upstream PR: https://github.com/jkff/splot/pull/9
  splot = appendPatch (fetchpatch {
    url = "https://github.com/jkff/splot/commit/a6710b05470d25cb5373481cf1cfc1febd686407.patch";
    sha256 = "1c5ck2ibag2gcyag6rjivmlwdlp5k0dmr8nhk7wlkzq2vh7zgw63";
  }) super.splot;

  # Support ansi-terminal 1.1: https://github.com/facebookincubator/retrie/pull/73
  retrie = appendPatch (fetchpatch {
    url = "https://github.com/facebookincubator/retrie/commit/b0df07178133b5b049e3e7764acba0e5e3fa57af.patch";
    sha256 = "sha256-Ea/u6PctSxy4h8VySjOwD2xW3TbwY1qE49dG9Av1SbQ=";
  }) super.retrie;

  # Fails with encoding problems, likely needs locale data.
  # Test can be executed by adding which to testToolDepends and
  # $PWD/dist/build/haskeline-examples-Test to $PATH.
  haskeline_0_8_3_0 = doDistribute (dontCheck super.haskeline_0_8_3_0);

  # Test suite fails to compile https://github.com/agrafix/Spock/issues/177
  Spock = dontCheck super.Spock;

  Spock-core = appendPatches [
    (fetchpatch {
      url = "https://github.com/agrafix/Spock/commit/d0b51fa60a83bfa5c1b5fc8fced18001e7321701.patch";
      sha256 = "sha256-l9voiczOOdYVBP/BNEUvqARb21t0Rp2kpsNbRFUWSLg=";
      stripLen = 1;
    })
  ] (doJailbreak super.Spock-core);

  hcoord = overrideCabal (drv: {
    # Remove when https://github.com/danfran/hcoord/pull/8 is merged.
    patches = [
      (fetchpatch {
        url = "https://github.com/danfran/hcoord/pull/8/commits/762738b9e4284139f5c21f553667a9975bad688e.patch";
        sha256 = "03r4jg9a6xh7w3jz3g4bs7ff35wa4rrmjgcggq51y0jc1sjqvhyz";
      })
    ];
    # Remove when https://github.com/danfran/hcoord/issues/9 is closed.
    doCheck = false;
  }) super.hcoord;

  # Break infinite recursion via tasty
  temporary = dontCheck super.temporary;

  # Break infinite recursion via doctest-lib
  utility-ht = dontCheck super.utility-ht;

  # Break infinite recursion via optparse-applicative (alternatively, dontCheck syb)
  prettyprinter-ansi-terminal = dontCheck super.prettyprinter-ansi-terminal;

  # Tests rely on `Int` being 64-bit: https://github.com/hspec/hspec/issues/431.
  # Also, we need QuickCheck-2.14.x to build the test suite, which isn't easy in LTS-16.x.
  # So let's not go there and just disable the tests altogether.
  hspec-core = dontCheck super.hspec-core;

  update-nix-fetchgit =
    let
      # Deps are required during the build for testing and also during execution,
      # so add them to build input and also wrap the resulting binary so they're in
      # PATH.
      deps = [
        pkgs.git
        pkgs.nix
        pkgs.nix-prefetch-git
      ];
    in
    lib.pipe super.update-nix-fetchgit [
      # 2023-06-26: Test failure: https://hydra.nixos.org/build/225081865
      dontCheck
      (self.generateOptparseApplicativeCompletions [ "update-nix-fetchgit" ])
      (overrideCabal (drv: {
        buildTools = drv.buildTools or [ ] ++ [ pkgs.buildPackages.makeWrapper ];
        postInstall = drv.postInstall or "" + ''
          wrapProgram "$out/bin/update-nix-fetchgit" --prefix 'PATH' ':' "${lib.makeBinPath deps}"
        '';
      }))
      (addTestToolDepends deps)
      # Patch for hnix compat.
      (appendPatches [
        (fetchpatch {
          url = "https://github.com/expipiplus1/update-nix-fetchgit/commit/dfa34f9823e282aa8c5a1b8bc95ad8def0e8d455.patch";
          sha256 = "sha256-yBjn1gVihVTlLewKgJc2I9gEj8ViNBAmw0bcsb5rh1A=";
          excludes = [ "cabal.project" ];
        })
        # Fix for GHC >= 9.8
        (fetchpatch {
          name = "update-nix-fetchgit-base-4.19.patch";
          url = "https://github.com/expipiplus1/update-nix-fetchgit/commit/384d2e259738abf94f5a20717b12648996cf24e2.patch";
          sha256 = "11489rpxrrz98f7d3j9mz6npgfg0zp005pghxv9c86rkyg5b10d5";
        })
      ])
    ];

  # Raise version bounds: https://github.com/idontgetoutmuch/binary-low-level/pull/16
  binary-strict = appendPatches [
    (fetchpatch {
      url = "https://github.com/idontgetoutmuch/binary-low-level/pull/16/commits/c16d06a1f274559be0dea0b1f7497753e1b1a8ae.patch";
      sha256 = "sha256-deSbudy+2je1SWapirWZ1IVWtJ0sJVR5O/fnaAaib2g=";
    })
  ] super.binary-strict;

  # The tests for semver-range need to be updated for the MonadFail change in
  # ghc-8.8:
  # https://github.com/adnelson/semver-range/issues/15
  semver-range = dontCheck super.semver-range;

  # 2024-03-02: vty <5.39 - https://github.com/reflex-frp/reflex-ghci/pull/33
  reflex-ghci = warnAfterVersion "0.2.0.1" (doJailbreak super.reflex-ghci);

  # 2024-09-18: transformers <0.5  https://github.com/reflex-frp/reflex-gloss/issues/6
  reflex-gloss = warnAfterVersion "0.2" (doJailbreak super.reflex-gloss);

  # 2024-09-18: primitive <0.8  https://gitlab.com/Kritzefitz/reflex-gi-gtk/-/merge_requests/20
  reflex-gi-gtk = warnAfterVersion "0.2.0.1" (doJailbreak super.reflex-gi-gtk);

  # Due to tests restricting base in 0.8.0.0 release
  http-media = doJailbreak super.http-media;

  # 2022-03-19: strict upper bounds https://github.com/poscat0x04/hinit/issues/2
  hinit = doJailbreak (self.generateOptparseApplicativeCompletions [ "hi" ] super.hinit);

  # 2020-11-23: https://github.com/Rufflewind/blas-hs/issues/8
  blas-hs = dontCheck super.blas-hs;

  # Strange doctest problems
  # https://github.com/biocad/servant-openapi3/issues/30
  servant-openapi3 = dontCheck super.servant-openapi3;

  # Disable test cases that were broken by insignificant changes in icu 76
  # https://github.com/haskell/text-icu/issues/108
  text-icu = overrideCabal (drv: {
    testFlags = drv.testFlags or [ ] ++ [
      "-t"
      "!Test cases"
    ];
  }) super.text-icu;

  hercules-ci-agent = self.generateOptparseApplicativeCompletions [
    "hercules-ci-agent"
  ] super.hercules-ci-agent;

  hercules-ci-cli = lib.pipe super.hercules-ci-cli [
    unmarkBroken
    (overrideCabal (drv: {
      hydraPlatforms = super.hercules-ci-cli.meta.platforms;
    }))
    # See hercules-ci-optparse-applicative in non-hackage-packages.nix.
    (addBuildDepend super.hercules-ci-optparse-applicative)
    (self.generateOptparseApplicativeCompletions [ "hci" ])
  ];

  # https://github.com/k0001/pipes-aeson/pull/21
  pipes-aeson = appendPatch (fetchpatch {
    url = "https://github.com/k0001/pipes-aeson/commit/08c25865ef557b41d7e4a783f52e655d2a193e18.patch";
    relative = "pipes-aeson";
    sha256 = "sha256-kFV6CcwKdMq+qSgyc+eIApnaycq5A++pEEVr2A9xvts=";
  }) super.pipes-aeson;

  moto-postgresql = appendPatches [
    # https://gitlab.com/k0001/moto/-/merge_requests/3
    (fetchpatch {
      name = "moto-postgresql-monadfail.patch";
      url = "https://gitlab.com/k0001/moto/-/commit/09cc1c11d703c25f6e81325be6482dc7ec6cbf58.patch";
      relative = "moto-postgresql";
      sha256 = "sha256-f2JVX9VveShCeV+T41RQgacpUoh1izfyHlE6VlErkZM=";
    })
  ] super.moto-postgresql;

  moto = appendPatches [
    # https://gitlab.com/k0001/moto/-/merge_requests/3
    (fetchpatch {
      name = "moto-ghc-9.0.patch";
      url = "https://gitlab.com/k0001/moto/-/commit/5b6f015a1271765005f03762f1f1aaed3a3198ed.patch";
      relative = "moto";
      sha256 = "sha256-RMa9tk+2ip3Ks73UFv9Ea9GEnElRtzIjdpld1Fx+dno=";
    })
  ] super.moto;

  # Readline uses Distribution.Simple from Cabal 2, in a way that is not
  # compatible with Cabal 3. No upstream repository found so far
  readline = appendPatch ./patches/readline-fix-for-cabal-3.patch super.readline;

  # DerivingVia is not allowed in safe Haskell
  # https://github.com/strake/util.hs/issues/1
  util = appendConfigureFlags [
    "--ghc-option=-fno-safe-haskell"
    "--haddock-option=--optghc=-fno-safe-haskell"
  ] super.util;
  category = appendConfigureFlags [
    "--ghc-option=-fno-safe-haskell"
    "--haddock-option=--optghc=-fno-safe-haskell"
  ] super.category;
  alg = appendConfigureFlags [
    "--ghc-option=-fno-safe-haskell"
    "--haddock-option=--optghc=-fno-safe-haskell"
  ] super.alg;

  # 2025-02-11: Too strict bounds on hedgehog < 1.5
  nothunks = doJailbreak super.nothunks;

  # Test suite fails, upstream not reachable for simple fix (not responsive on github)
  vivid-supercollider = dontCheck super.vivid-supercollider;

  # Test suite does not compile.
  feed = dontCheck super.feed;

  spacecookie = overrideCabal (old: {
    buildTools = (old.buildTools or [ ]) ++ [ pkgs.buildPackages.installShellFiles ];
    # let testsuite discover the resulting binary
    preCheck = ''
      export SPACECOOKIE_TEST_BIN=./dist/build/spacecookie/spacecookie
    ''
    + (old.preCheck or "");
    # install man pages shipped in the sdist
    postInstall = ''
      installManPage docs/man/*
    ''
    + (old.postInstall or "");
  }) super.spacecookie;

  # Patch and jailbreak can be removed at next release, chatter > 0.9.1.0
  # * Remove dependency on regex-tdfa-text
  # * Jailbreak as bounds on cereal are too strict
  # * Disable test suite which doesn't compile
  #   https://github.com/creswick/chatter/issues/38
  chatter = appendPatch (fetchpatch {
    url = "https://github.com/creswick/chatter/commit/e8c15a848130d7d27b8eb5e73e8a0db1366b2e62.patch";
    sha256 = "1dzak8d12h54vss5fxnrclygz0fz9ygbqvxd5aifz5n3vrwwpj3g";
  }) (dontCheck (doJailbreak (super.chatter.override { regex-tdfa-text = null; })));

  # test suite doesn't compile anymore due to changed hunit/tasty APIs
  fullstop = dontCheck super.fullstop;

  # * doctests don't work without cabal
  #   https://github.com/noinia/hgeometry/issues/132
  # * Too strict version bound on vector-builder
  #   https://github.com/noinia/hgeometry/commit/a6abecb1ce4a7fd96b25cc1a5c65cd4257ecde7a#commitcomment-49282301
  hgeometry-combinatorial = dontCheck (doJailbreak super.hgeometry-combinatorial);

  # Too strict bounds on containers
  # https://github.com/jswebtools/language-ecmascript-analysis/issues/1
  language-ecmascript-analysis = doJailbreak super.language-ecmascript-analysis;

  cli-git = addBuildTool pkgs.git super.cli-git;

  cli-nix = addBuildTools [
    pkgs.nix
    pkgs.nix-prefetch-git
  ] super.cli-nix;

  # list `modbus` in librarySystemDepends, correct to `libmodbus`
  libmodbus = doJailbreak (addExtraLibrary pkgs.libmodbus super.libmodbus);

  # Too strict version bounds on ghc-events
  # https://github.com/mpickering/hs-speedscope/issues/16
  hs-speedscope = doJailbreak super.hs-speedscope;

  # Missing test files in sdist tarball:
  # https://gitlab.com/dpwiz/geomancy-layout/-/issues/1
  geomancy-layout = dontCheck super.geomancy-layout;

  # 2025-02-11: Too strict bounds on base < 4.19, bytestring < 0.12, tasty < 1.5, tasty-quickcheck < 0.11
  blake2 = doJailbreak super.blake2;

  # Test suite doesn't support base16-bytestring >= 1.0
  # https://github.com/serokell/haskell-crypto/issues/25
  crypto-sodium = dontCheck super.crypto-sodium;

  # 2021-04-09: too strict time bound
  # PR pending https://github.com/zohl/cereal-time/pull/2
  cereal-time = doJailbreak super.cereal-time;

  # 2021-04-16: too strict bounds on QuickCheck and tasty
  # https://github.com/hasufell/lzma-static/issues/1
  lzma-static = doJailbreak super.lzma-static;

  # Too strict version bounds on base:
  # https://github.com/obsidiansystems/database-id/issues/1
  database-id-class = doJailbreak super.database-id-class;

  # Too strict version bounds on base
  # https://github.com/gibiansky/IHaskell/issues/1217
  ihaskell-display = doJailbreak super.ihaskell-display;
  ihaskell-basic = doJailbreak super.ihaskell-basic;

  # Tests need to lookup target triple x86_64-unknown-linux
  # https://github.com/llvm-hs/llvm-hs/issues/334
  llvm-hs = dontCheckIf (pkgs.stdenv.targetPlatform.system != "x86_64-linux") super.llvm-hs;

  # Fix build with bytestring >= 0.11 (GHC 9.2)
  # https://github.com/llvm-hs/llvm-hs/pull/389
  llvm-hs-pure =
    appendPatches
      [
        (fetchpatch {
          name = "llvm-hs-pure-bytestring-0.11.patch";
          url = "https://github.com/llvm-hs/llvm-hs/commit/fe8fd556e8d2cc028f61d4d7b4b6bf18c456d090.patch";
          sha256 = "sha256-1d4wQg6JEJL3GwmXQpvbW7VOY5DwjUPmIsLEEur0Kps=";
          relative = "llvm-hs-pure";
          excludes = [ "**/Triple.hs" ]; # doesn't exist in 9.0.0
        })
      ]
      (
        overrideCabal {
          # Hackage Revision prevents patch from applying. Revision 1 does not allow
          # bytestring-0.11.4 which is bundled with 9.2.6.
          editedCabalFile = null;
          revision = null;
        } super.llvm-hs-pure
      );

  # 2025-02-11: Too strict bounds on tasty-quickcheck < 0.11
  exact-pi = doJailbreak super.exact-pi;

  # Too strict bounds on dimensional
  # https://github.com/enomsg/science-constants-dimensional/pull/1
  science-constants-dimensional = doJailbreak super.science-constants-dimensional;

  # Tests are flaky on busy machines, upstream doesn't intend to fix
  # https://github.com/merijn/paramtree/issues/4
  paramtree = dontCheck super.paramtree;

  # Flaky test suites
  ticker = dontCheck super.ticker;
  powerqueue-distributed = dontCheck super.powerqueue-distributed;
  job = dontCheck super.job;
  scheduler = dontCheck super.scheduler;

  # 2024-09-18: Make compatible with haskell-gi 0.26.10
  # https://github.com/owickstrom/gi-gtk-declarative/pull/118
  gi-gtk-declarative = warnAfterVersion "0.7.1" (
    overrideCabal (drv: {
      jailbreak = true;
      postPatch = ''
        sed -i '1 i {-# LANGUAGE FlexibleContexts #-}' \
          src/GI/Gtk/Declarative/Widget/Conversions.hs
      '';
    }) super.gi-gtk-declarative
  );
  gi-gtk-declarative-app-simple = doJailbreak super.gi-gtk-declarative-app-simple;

  # FIXME: These should be removed as gi-gtk4/gi-gdk4 become the standard
  gi-gtk_4 = self.gi-gtk_4_0_12;
  gi-gdk_4 = self.gi-gdk_4_0_10;

  # 2023-04-09: haskell-ci needs Cabal-syntax 3.10
  # 2024-03-21: pins specific version of ShellCheck
  # 2025-03-10: jailbreak, https://github.com/haskell-CI/haskell-ci/issues/771
  haskell-ci = doJailbreak (
    super.haskell-ci.overrideScope (
      self: super: {
        Cabal-syntax = self.Cabal-syntax_3_10_3_0;
        ShellCheck = self.ShellCheck_0_9_0;
      }
    )
  );

  stack = super.stack.overrideScope (
    self: super: {
      # stack needs to be built with the same hpack version that the upstream releases use.
      # https://github.com/NixOS/nixpkgs/issues/223390
      hpack = self.hpack_0_38_1;
    }
  );

  # ShellCheck < 0.10.0 needs to be adjusted for changes in fgl >= 5.8
  # https://github.com/koalaman/shellcheck/issues/2677
  ShellCheck_0_9_0 = doJailbreak (
    appendPatches [
      (fetchpatch {
        name = "shellcheck-fgl-5.8.1.1.patch";
        url = "https://github.com/koalaman/shellcheck/commit/c05380d518056189412e12128a8906b8ca6f6717.patch";
        sha256 = "0gbx46x1a2sh5mvgpqxlx9xkqcw4wblpbgqdkqccxdzf7vy50xhm";
      })
    ] super.ShellCheck_0_9_0
  );

  # Too strict bound on hspec (<2.11)
  utf8-light = doJailbreak super.utf8-light;

  # BSON defaults to requiring network instead of network-bsd which is
  # required nowadays: https://github.com/mongodb-haskell/bson/issues/26
  bson = appendConfigureFlag "-f-_old_network" (
    super.bson.override {
      network = self.network-bsd;
    }
  );

  # Disable flaky tests
  # https://github.com/DavidEichmann/alpaca-netcode/issues/2
  alpaca-netcode = overrideCabal {
    testFlags = [
      "--pattern"
      "!/[NOCI]/"
    ];
  } super.alpaca-netcode;

  # 2021-05-22: Tests fail sometimes (even consistently on hydra)
  # when running a fs-related test with >= 12 jobs. To work around
  # this, run tests with only a single job.
  # https://github.com/vmchale/libarchive/issues/20
  libarchive = overrideCabal {
    testFlags = [ "-j1" ];
  } super.libarchive;

  # https://github.com/plow-technologies/hspec-golden-aeson/issues/17
  hspec-golden-aeson = dontCheck super.hspec-golden-aeson;

  # To strict bound on hspec
  # https://github.com/dagit/zenc/issues/5
  zenc = doJailbreak super.zenc;

  # https://github.com/ajscholl/basic-cpuid/pull/1
  basic-cpuid = appendPatch (fetchpatch {
    url = "https://github.com/ajscholl/basic-cpuid/commit/2f2bd7a7b53103fb0cf26883f094db9d7659887c.patch";
    sha256 = "0l15ccfdys100jf50s9rr4p0d0ikn53bkh7a9qlk9i0y0z5jc6x1";
  }) super.basic-cpuid;

  # Allow building with language-docker >= 13 (!); waiting for 2.13 release.
  hadolint = doJailbreak (
    appendPatches [
      (pkgs.fetchpatch {
        name = "hadolint-language-docker-12.patch";
        url = "https://github.com/hadolint/hadolint/commit/593ccde5af13c9b960b3ea815c47ce028a2e8adc.patch";
        sha256 = "07v5c1k8if72j04m017jpsf7gvc5kwyi1q3a532n0zhxqc7w1zjn";
        includes = [
          "**/DL3011.hs"
          "**/DL3011Spec.hs"
        ];
      })
    ] super.hadolint
  );

  # Too strict lower bounds on (test) deps
  # https://github.com/phadej/puresat/issues/6
  puresat = doJailbreak super.puresat;

  # test suite requires stack to run, https://github.com/dino-/photoname/issues/24
  photoname = dontCheck super.photoname;

  # Upgrade of unordered-containers in Stackage causes ordering-sensitive test to fail
  # https://github.com/commercialhaskell/stackage/issues/6366
  # https://github.com/kapralVV/Unique/issues/9
  # Too strict bounds on hashable
  # https://github.com/kapralVV/Unique/pull/10
  Unique = warnAfterVersion "0.4.7.9" (
    overrideCabal (drv: {
      testFlags = [
        "--skip"
        "/Data.List.UniqueUnsorted.removeDuplicates/removeDuplicates: simple test/"
        "--skip"
        "/Data.List.UniqueUnsorted.repeatedBy,repeated,unique/unique: simple test/"
        "--skip"
        "/Data.List.UniqueUnsorted.repeatedBy,repeated,unique/repeatedBy: simple test/"
      ]
      ++ drv.testFlags or [ ];
    }) super.Unique
  );

  # https://github.com/AndrewRademacher/aeson-casing/issues/8
  aeson-casing = warnAfterVersion "0.2.0.0" (
    overrideCabal (drv: {
      testFlags = [
        "-p"
        "! /encode train/"
      ]
      ++ drv.testFlags or [ ];
    }) super.aeson-casing
  );

  # https://github.com/emc2/HUnit-Plus/issues/26
  HUnit-Plus = dontCheck super.HUnit-Plus;
  # https://github.com/ewestern/haskell-postgis/issues/7
  haskell-postgis = overrideCabal (drv: {
    testFlags = [
      "--skip"
      "/Geo/Hexable/Encodes a linestring/"
    ]
    ++ drv.testFlags or [ ];
  }) super.haskell-postgis;
  # https://github.com/ChrisPenner/json-to-haskell/issues/5
  json-to-haskell = overrideCabal (drv: {
    testFlags = [
      "--match"
      "/should sanitize weird field and record names/"
    ]
    ++ drv.testFlags or [ ];
  }) super.json-to-haskell;
  # https://github.com/fieldstrength/aeson-deriving/issues/5
  aeson-deriving = dontCheck super.aeson-deriving;

  # 2025-02-11: Too strict bounds on tasty < 1.5, all of the below.
  morpheus-graphql-app = doJailbreak super.morpheus-graphql-app;
  morpheus-graphql-client = doJailbreak super.morpheus-graphql-client;
  morpheus-graphql-core = doJailbreak super.morpheus-graphql-core;
  morpheus-graphql-server = doJailbreak super.morpheus-graphql-server;
  morpheus-graphql-tests = doJailbreak super.morpheus-graphql-tests;
  morpheus-graphql = doJailbreak super.morpheus-graphql;

  drunken-bishop = doJailbreak super.drunken-bishop;
  # https://github.com/SupercedeTech/dropbox-client/issues/1
  dropbox = overrideCabal (drv: {
    testFlags = [
      "--skip"
      "/Dropbox/Dropbox aeson aeson/encodes list folder correctly/"
    ]
    ++ drv.testFlags or [ ];
  }) super.dropbox;
  # https://github.com/alonsodomin/haskell-schema/issues/11
  hschema-aeson = overrideCabal (drv: {
    testFlags = [
      "--skip"
      "/toJsonSerializer/should generate valid JSON/"
    ]
    ++ drv.testFlags or [ ];
  }) super.hschema-aeson;
  # https://github.com/minio/minio-hs/issues/165
  # https://github.com/minio/minio-hs/pull/191 Use crypton-connection instead of unmaintained connection
  minio-hs = overrideCabal (drv: {
    testFlags = [
      "-p"
      "!/Test mkSelectRequest/"
    ]
    ++ drv.testFlags or [ ];
    patches = drv.patches or [ ] ++ [
      (pkgs.fetchpatch {
        name = "use-crypton-connection.patch";
        url = "https://github.com/minio/minio-hs/commit/786cf1881f0b62b7539e63547e76afc3c1ade36a.patch";
        sha256 = "sha256-zw0/jhKzShpqV1sUyxWTl73sQOzm6kA/yQOZ9n0L1Ag";
      })
      (pkgs.fetchpatch {
        name = "compatibility-with-crypton-connection-0-4-0.patch";
        url = "https://github.com/minio/minio-hs/commit/e2169892a5fea444aaf9e551243da811003d3188.patch";
        sha256 = "sha256-hWphiArv7gZWiDewLHDeU4RASGOE9Z1liahTmAGQIgQ=";
      })
    ];
  }) (super.minio-hs.override { connection = self.crypton-connection; });

  # Invalid CPP in test suite: https://github.com/cdornan/memory-cd/issues/1
  memory-cd = dontCheck super.memory-cd;

  fgl-arbitrary = doJailbreak super.fgl-arbitrary;

  # raaz-0.3 onwards uses backpack and it does not play nicely with
  # parallel builds using -j
  #
  # See: https://gitlab.haskell.org/ghc/ghc/-/issues/17188
  #
  # Overwrite the build cores
  raaz = disableParallelBuilding super.raaz;

  # Test suite uses SHA as a point of comparison which doesn't
  # succeeds its own test suite on 32bit:
  # https://github.com/GaloisInc/SHA/issues/16
  cryptohash-sha256 =
    if pkgs.stdenv.hostPlatform.is32bit then
      dontCheck super.cryptohash-sha256
    else
      super.cryptohash-sha256;

  # https://github.com/andreymulik/sdp/issues/3
  sdp = disableLibraryProfiling super.sdp;
  sdp-binary = disableLibraryProfiling super.sdp-binary;
  sdp-deepseq = disableLibraryProfiling super.sdp-deepseq;
  sdp-hashable = disableLibraryProfiling super.sdp-hashable;
  sdp-io = disableLibraryProfiling super.sdp-io;
  sdp-quickcheck = disableLibraryProfiling super.sdp-quickcheck;
  sdp4bytestring = disableLibraryProfiling super.sdp4bytestring;
  sdp4text = disableLibraryProfiling super.sdp4text;
  sdp4unordered = disableLibraryProfiling super.sdp4unordered;
  sdp4vector = disableLibraryProfiling super.sdp4vector;

  # Fixes compilation with GHC 9.0 and above
  # https://hub.darcs.net/shelarcy/regex-compat-tdfa/issue/3
  regex-compat-tdfa =
    appendPatches
      [
        ./patches/regex-compat-tdfa-ghc-9.0.patch
      ]
      (
        overrideCabal {
          # Revision introduces bound base < 4.15
          revision = null;
          editedCabalFile = null;
        } super.regex-compat-tdfa
      );

  # 2025-02-11: Too strict bounds on hedgehog < 1.5, hspec-hedgehog < 0.2
  validation-selective = doJailbreak super.validation-selective;

  # Test suite isn't supposed to succeed yet, apparently…
  # https://github.com/andrewufrank/uniform-error/blob/f40629ad119e90f8dae85e65e93d7eb149bddd53/test/Uniform/Error_test.hs#L124
  # https://github.com/andrewufrank/uniform-error/issues/2
  uniform-error = dontCheck super.uniform-error;
  # https://github.com/andrewufrank/uniform-fileio/issues/2
  uniform-fileio = dontCheck super.uniform-fileio;

  # The shipped Setup.hs file is broken.
  csv = overrideCabal (drv: { preCompileBuildDriver = "rm Setup.hs"; }) super.csv;
  # Build-type is simple, but ships a broken Setup.hs
  digits = overrideCabal (drv: { preCompileBuildDriver = "rm Setup.lhs"; }) super.digits;

  cabal-fmt = doJailbreak (
    super.cabal-fmt.override {
      # Needs newer Cabal-syntax version.
      Cabal-syntax = self.Cabal-syntax_3_10_3_0;
    }
  );

  # 2025-02-11: Too strict bounds on base < 4.17
  ema = doJailbreak super.ema;

  # Too strict bounds on text and tls
  # https://github.com/barrucadu/irc-conduit/issues/54
  # Use crypton-connection instead of connection
  # https://github.com/barrucadu/irc-conduit/pull/60 https://github.com/barrucadu/irc-client/pull/101
  irc-conduit =
    appendPatch
      (pkgs.fetchpatch {
        url = "https://github.com/barrucadu/irc-conduit/pull/60/commits/58f6b5ee0c23a0615e43292dbbacf40636dcd7a6.patch";
        hash = "sha256-d08tb9iL07mBWdlZ7PCfTLVFJLgcxeGVPzJ+jOej8io=";
      })
      (
        doJailbreak (
          super.irc-conduit.override {
            connection = self.crypton-connection;
            x509-validation = self.crypton-x509-validation;
          }
        )
      );
  irc-client =
    appendPatch
      (pkgs.fetchpatch {
        url = "https://github.com/barrucadu/irc-client/pull/101/commits/0440b7e2ce943d960234c50957a55025771f567a.patch";
        hash = "sha256-iZyZMrodgViXFCMH9y2wIJZRnjd6WhkqInAdykqTdkY=";
      })
      (
        doJailbreak (
          super.irc-client.override {
            connection = self.crypton-connection;
            x509 = self.crypton-x509;
            x509-store = self.crypton-x509-store;
            x509-validation = self.crypton-x509-validation;
          }
        )
      );

  # 2022-03-16: Upstream stopped updating bounds https://github.com/haskell-hvr/base-noprelude/pull/15
  base-noprelude = doJailbreak super.base-noprelude;

  # 2025-01-07: unreleased upstream supports hedgehog 1.5 but drifted quite a bit from hackage revisions so hard to patch
  hw-hspec-hedgehog = doJailbreak super.hw-hspec-hedgehog;

  # Test suite doesn't support hspec 2.8
  # https://github.com/zellige/hs-geojson/issues/29
  geojson = dontCheck super.geojson;

  # Test data missing from sdist
  # https://github.com/ngless-toolkit/ngless/issues/152
  NGLess = dontCheck super.NGLess;

  # Too strict bound on network (<3.2)
  hookup = appendPatches [
    (pkgs.fetchpatch {
      name = "hookup-network-3.2.patch";
      url = "https://github.com/glguy/irc-core/commit/a3ec982e729b0f77b2db336ec32c5e4b7283bed5.patch";
      sha256 = "0qc1qszn3l69xlbpfv8vz9ld0q7sghfcbp0wjds81kwcpdpl4jgv";
      stripLen = 1;
      includes = [ "hookup.cabal" ];
    })
  ] super.hookup;

  # Raise version bounds: https://github.com/kosmikus/records-sop/pull/15
  records-sop = appendPatch (fetchpatch {
    url = "https://github.com/kosmikus/records-sop/commit/fb149f453a816ff14d0cb20b3ea56b80ff49d9f1.patch";
    sha256 = "sha256-iHiF4EWL/GjJFnr/6aR+yMZKLMLAZK+gsgSxG8YaeDI=";
  }) super.records-sop;

  # Fix build failures for ghc 9 (https://github.com/mokus0/polynomial/pull/20)
  polynomial =
    appendPatch
      (fetchpatch {
        name = "haskell-polynomial.20.patch";
        url = "https://github.com/mokus0/polynomial/pull/20.diff";
        sha256 = "1bwivimpi2hiil3zdnl5qkds1inyn239wgxbn3y8l2pwyppnnfl0";
      })
      (
        overrideCabal (drv: {
          revision = null;
          editedCabalFile = null;
          doCheck = false; # Source dist doesn't include the checks
        }) super.polynomial
      );

  # lucid-htmx has restrictive upper bounds on lucid and servant:
  #
  #   Setup: Encountered missing or private dependencies:
  #   lucid >=2.9.12.1 && <=2.11, servant >=0.18.3 && <0.19
  #
  # Can be removed once
  #
  # > https://github.com/MonadicSystems/lucid-htmx/issues/6
  #
  # has been resolved.
  lucid-htmx = doJailbreak super.lucid-htmx;

  clash-prelude = dontCheck super.clash-prelude;

  krank = appendPatches [
    # Deal with removed exports in base
    (pkgs.fetchpatch {
      name = "krank-issue-97.patch";
      url = "https://github.com/guibou/krank/commit/f6b676774537f8e2357115fd8cd3c93fb68e8a85.patch";
      sha256 = "0d85q2x37yhjwp17wmqvblkna7p7vnl7rwdqr3kday46wvdgblgl";
      excludes = [ ".envrc" ];
    })
    # Fix build of tests with http-client >=0.7.16
    (pkgs.fetchpatch {
      name = "krank-http-client-0.7.16.patch";
      url = "https://github.com/guibou/krank/commit/50fd3d08526f3ed6add3352460d3d1ce9dc15f6d.patch";
      sha256 = "0h15iir2v4pli2b72gv69amxs277xmmzw3wavrix74h9prbs4pms";
    })
  ] super.krank;

  hermes-json = overrideCabal (drv: {
    # 2025-02-11: Upper bounds on hedgehog < 1.5 too strict.
    jailbreak = true;

    # vendored simdjson breaks with clang-19. apply patches that work with
    # a more recent simdjson so we can un-vendor it
    patches = drv.patches or [ ] ++ [
      (fetchpatch {
        url = "https://github.com/velveteer/hermes/commit/6fd9904d93a5c001aadb27c114345a6958904d71.patch";
        hash = "sha256-Pv09XP0/VjUiAFp237Adj06PIZU21mQRh7guTlKksvA=";
        excludes = [
          ".github/*"
          "hermes-bench/*"
        ];
      })
      (fetchpatch {
        url = "https://github.com/velveteer/hermes/commit/ca8dddbf52f9d7788460a056fefeb241bcd09190.patch";
        hash = "sha256-tDDGS0QZ3YWe7+SP09wnxx6lIWL986ce5Zhqr7F2sBk=";
        excludes = [
          "README.md"
          ".github/*"
          "hermes-bench/*"
        ];
      })
    ];
    postPatch = drv.postPatch or "" + ''
      ln -fs ${pkgs.simdjson.src} simdjson
    '';
  }) super.hermes-json;

  # hexstring is not compatible with newer versions of base16-bytestring
  # See https://github.com/solatis/haskell-hexstring/issues/3
  hexstring = overrideCabal (old: {
    # Prevent DOS line endings from Hackage from breaking a patch
    prePatch = old.prePatch or "" + ''
      ${pkgs.buildPackages.dos2unix}/bin/dos2unix src/Data/HexString.hs
    '';
    patches = old.patches or [ ] ++ [
      (pkgs.fetchpatch {
        name = "fix-base16-bytestring-compat";
        url = "https://github.com/solatis/haskell-hexstring/commit/4f0a27c64ecb4a767eeea2efebebfd7edba18de0.patch";
        hash = "sha256-DHT566Ov1D++1VNjUor9xSeOsuSi2LPiIAGT55gqr8s=";
      })
    ];
  }) super.hexstring;

  # Disabling doctests.
  regex-tdfa = overrideCabal {
    testTargets = [ "regex-tdfa-unittest" ];
  } super.regex-tdfa;

  # Missing test files https://github.com/kephas/xdg-basedir-compliant/issues/1
  xdg-basedir-compliant = dontCheck super.xdg-basedir-compliant;

  # Test failure after libxcrypt migration, reported upstream at
  # https://github.com/phadej/crypt-sha512/issues/13
  crypt-sha512 = dontCheck super.crypt-sha512;

  # Latest release depends on crypton-connection ==0.3.2 https://github.com/ndmitchell/hoogle/issues/435
  hoogle = overrideSrc {
    version = "unstable-2024-07-29";
    src = pkgs.fetchFromGitHub {
      owner = "ndmitchell";
      repo = "hoogle";
      rev = "8149c93c40a542bf8f098047e1acbc347fc9f4e6";
      hash = "sha256-k3UdmTq8c+iNF8inKM+oWf/NgJqRgUSFS3YwRKVg8Mw=";
    };
  } super.hoogle;

  inherit
    (
      let
        # We need to build purescript with these dependencies and thus also its reverse
        # dependencies to avoid version mismatches in their dependency closure.
        # TODO: maybe unify with the spago overlay in configuration-nix.nix?
        purescriptOverlay = self: super: {
          # As of 2021-11-08, the latest release of `language-javascript` is 0.7.1.0,
          # but it has a problem with parsing the `async` keyword.  It doesn't allow
          # `async` to be used as an object key:
          # https://github.com/erikd/language-javascript/issues/131
          language-javascript = self.language-javascript_0_7_0_0;
        };
      in
      {
        purescript = lib.pipe (super.purescript.overrideScope purescriptOverlay) [
          # https://github.com/purescript/purescript/pull/4547
          (appendPatches [
            (pkgs.fetchpatch {
              name = "purescript-import-fix";
              url = "https://github.com/purescript/purescript/commit/c610ec18391139a67dc9dcf19233f57d2c5413f7.patch";
              hash = "sha256-7s/ygzAFJ1ocZIj3OSd3TbsmGki46WViPIZOU1dfQFg=";
            })
          ])
          # PureScript uses nodejs to run tests, so the tests have been disabled
          # for now.  If someone is interested in figuring out how to get this
          # working, it seems like it might be possible.
          dontCheck
          # The current version of purescript (0.14.5) has version bounds for LTS-17,
          # but it compiles cleanly using deps in LTS-18 as well.  This jailbreak can
          # likely be removed when purescript-0.14.6 is released.
          doJailbreak
          # Generate shell completions
          (self.generateOptparseApplicativeCompletions [ "purs" ])
        ];

        purenix = lib.pipe (super.purenix.overrideScope purescriptOverlay) [
          (appendPatches [
            # https://github.com/purenix-org/purenix/pull/63
            (pkgs.fetchpatch {
              name = "purenix-purescript-0_15_12";
              url = "https://github.com/purenix-org/purenix/commit/2dae563f887c7c8daf3dd3e292ee3580cb70d528.patch";
              hash = "sha256-EZXf95BJINyqnRb2t/Ao/9C8ttNp3A27rpKiEKJjO6Y=";
            })
            (pkgs.fetchpatch {
              name = "purenix-import-fix";
              url = "https://github.com/purenix-org/purenix/commit/f1890690264e7e5ce7f5b0a32d73d910ce2cbd73.patch";
              hash = "sha256-MRITcNOiaWmzlTd9l7sIz/LhlnpW8T02CXdcc1qQt3c=";
            })
          ])
        ];
      }
    )
    purescript
    purenix
    ;

  # containers <0.6, semigroupoids <5.3
  data-lens = doJailbreak super.data-lens;

  # hashable <1.4, mmorph <1.2
  composite-aeson = doJailbreak super.composite-aeson;

  # Overly strict bounds on tasty-quickcheck (test suite) (< 0.11)
  hashable = doJailbreak super.hashable;
  cborg = lib.pipe super.cborg [
    # Fix build on 32-bit: https://github.com/well-typed/cborg/pull/322
    (appendPatches (
      lib.optionals pkgs.stdenv.hostPlatform.is32bit [
        (pkgs.fetchpatch {
          name = "cborg-i686-1.patch";
          url = "https://github.com/well-typed/cborg/commit/a4757c46219afe6d235652ae642786f2e2977020.patch";
          sha256 = "01n0x2l605x7in9hriz9asmzsfb5f8d6zkwgypckfj1r18qbs2hj";
          includes = [ "**/Codec/CBOR/**" ];
          stripLen = 1;
        })
        (pkgs.fetchpatch {
          name = "cborg-i686-2.patch";
          url = "https://github.com/well-typed/cborg/commit/94a856e4e544a5bc7f927cfb728de385d6260af4.patch";
          sha256 = "03iz85gsll38q5bl3m024iv7yb1k5sisly7jvgf66zic8fbvkhcn";
          includes = [ "**/Codec/CBOR/**" ];
          stripLen = 1;
        })
      ]
    ))
  ];
  # Doesn't compile with tasty-quickcheck == 0.11 (see issue above)
  serialise = dontCheck super.serialise;
  # https://github.com/Bodigrim/data-array-byte/issues/1
  data-array-byte = doJailbreak super.data-array-byte;
  # 2025-02-06: Allow tasty-quickcheck == 0.11.*
  # https://github.com/google/ghc-source-gen/issues/120
  ghc-source-gen = doJailbreak super.ghc-source-gen;
  # https://github.com/byteverse/bytebuild/issues/20#issuecomment-2652113837
  bytebuild = doJailbreak super.bytebuild;
  # https://github.com/haskellari/lattices/issues/132
  lattices = doJailbreak super.lattices;

  # Too strict bounds on tasty <1.5 and tasty-quickcheck <0.11
  # https://github.com/phadej/aeson-extra/issues/62
  aeson-extra = doJailbreak super.aeson-extra;

  # Support tasty-quickcheck 0.11: https://github.com/Bodigrim/mod/pull/26
  mod = appendPatch (fetchpatch {
    url = "https://github.com/Bodigrim/mod/commit/30596fb9d85b69ec23ecb05ef9a7c91d67901cfd.patch";
    sha256 = "sha256-9XuzIxEbepaw5bRoIOUka8fkiZBfturIybh/9nhGmWQ=";
  }) super.mod;

  # Fixes build of test suite: not yet released
  primitive-unlifted = appendPatch (fetchpatch {
    url = "https://github.com/haskell-primitive/primitive-unlifted/commit/26922952ef20c4771d857f3e96c9e710cb3c2df9.patch";
    sha256 = "0h9xxrv78spqi93l9206398gmsliaz0w6xy37nrvx3daqr1y4big";
    excludes = [ "*.cabal" ];
  }) super.primitive-unlifted;

  # composite-aeson <0.8, composite-base <0.8
  compdoc = doJailbreak super.compdoc;

  # composite-aeson <0.8, composite-base <0.8
  haskell-coffee = doJailbreak super.haskell-coffee;

  # Test suite doesn't compile anymore
  twitter-types = dontCheck super.twitter-types;

  # Tests open file "data/test_vectors_aserti3-2d_run01.txt" but it doesn't exist
  haskoin-core = dontCheck super.haskoin-core;

  # unix-compat <0.5
  hxt-cache = doJailbreak super.hxt-cache;

  # QuickCheck <2.14
  term-rewriting = doJailbreak super.term-rewriting;

  # tests can't find the test binary anymore - parseargs-example
  parseargs = dontCheck super.parseargs;

  # base <4.14
  decimal-literals = doJailbreak super.decimal-literals;

  # Test failure https://gitlab.com/lysxia/ap-normalize/-/issues/2
  ap-normalize = dontCheck super.ap-normalize;

  heist-extra = doJailbreak super.heist-extra; # base <4.18.0.0.0
  unionmount = doJailbreak super.unionmount; # base <4.18
  tailwind = doJailbreak super.tailwind; # base <=4.17.0.0
  commonmark-wikilink = doJailbreak super.commonmark-wikilink; # base <4.18.0.0.0

  # 2024-03-02: Apply unreleased changes necessary for compatibility
  # with commonmark-extensions-0.2.5.3.
  commonmark-simple = warnAfterVersion "0.1.0.0" (
    appendPatches (map
      (
        { rev, hash }:
        fetchpatch {
          name = "commonmark-simple-${lib.substring 0 7 rev}.patch";
          url = "https://github.com/srid/commonmark-simple/commit/${rev}.patch";
          includes = [ "src/Commonmark/Simple.hs" ];
          inherit hash;
        }
      )
      [
        {
          rev = "71f5807ed4cbd8da915bf5ba04cd115b49980bcb";
          hash = "sha256-ibDQbyTd2BoA0V+ldMOr4XYurnqk1nWzbJ15tKizHrM=";
        }
        {
          rev = "fc106c94f781f6a35ef66900880edc08cbe3b034";
          hash = "sha256-9cpgRNFWhpSuSttAvnwPiLmi1sIoDSYbp0sMwcKWgDQ=";
        }
      ]
    ) (doJailbreak super.commonmark-simple)
  );

  # Test files missing from sdist
  # https://github.com/tweag/webauthn/issues/166
  webauthn = dontCheck super.webauthn;

  # calls ghc in tests
  # https://github.com/brandonchinn178/tasty-autocollect/issues/54
  tasty-autocollect = dontCheck super.tasty-autocollect;

  postgres-websockets = lib.pipe super.postgres-websockets [
    (addTestToolDepends [
      pkgs.postgresql
      pkgs.postgresqlTestHook
    ])
    (dontCheckIf pkgs.postgresqlTestHook.meta.broken)
    (overrideCabal {
      preCheck = ''
        export postgresqlEnableTCP=1
        export PGDATABASE=postgres_ws_test
      '';
    })
  ];

  postgrest =
    lib.pipe
      (super.postgrest.overrideScope (
        self: super: {
          # 2025-01-19: Upstream is stuck at hasql < 1.7
          # Jailbreaking for newer postgresql-libpq, which seems to work fine
          postgresql-binary = dontCheck (doJailbreak super.postgresql-binary_0_13_1_3);
          hasql = dontCheck (doJailbreak super.hasql_1_6_4_4);
          # Matching dependencies for hasql < 1.6.x
          hasql-dynamic-statements = dontCheck super.hasql-dynamic-statements_0_3_1_5;
          hasql-implicits = dontCheck super.hasql-implicits_0_1_1_3;
          hasql-notifications = dontCheck super.hasql-notifications_0_2_2_2;
          hasql-pool = dontCheck super.hasql-pool_1_0_1;
          hasql-transaction = dontCheck super.hasql-transaction_1_1_0_1;
        }
      ))
      [
        # 2023-12-20: New version needs extra dependencies
        (addBuildDepends [
          self.cache
          self.extra
          self.fuzzyset_0_2_4
          self.jose-jwt
          self.neat-interpolation
          self.prometheus-client
          self.timeit
        ])
        # 2022-12-02: Too strict bounds.
        doJailbreak
        # 2022-12-02: Hackage release lags behind actual releases: https://github.com/PostgREST/postgrest/issues/2275
        (overrideSrc rec {
          version = "13.0.4";
          src = pkgs.fetchFromGitHub {
            owner = "PostgREST";
            repo = "postgrest";
            rev = "v${version}";
            hash = "sha256-Y9Nxfs2w3Iinx61Om7dd+R8TTsK12oWD+3vki3WUz9Y=";
          };
        })
      ];

  # Too strict bounds on hspec < 2.11
  fuzzyset_0_2_4 = doJailbreak super.fuzzyset_0_2_4;

  html-charset = dontCheck super.html-charset;

  # bytestring <0.11.0, optparse-applicative <0.13.0
  # https://github.com/kseo/sfnt2woff/issues/1
  sfnt2woff = doJailbreak super.sfnt2woff;

  # libfuse3 fails to mount fuse file systems within the build environment
  libfuse3 = dontCheck super.libfuse3;

  # Merged upstream, but never released. Allows both intel and aarch64 darwin to build.
  # https://github.com/vincenthz/hs-gauge/pull/106
  gauge = appendPatch (pkgs.fetchpatch {
    name = "darwin-aarch64-fix.patch";
    url = "https://github.com/vincenthz/hs-gauge/commit/3d7776f41187c70c4f0b4517e6a7dde10dc02309.patch";
    hash = "sha256-4osUMo0cvTvyDTXF8lY9tQbFqLywRwsc3RkHIhqSriQ=";
  }) super.gauge;

  # The hackage source is somehow missing a file present in the repo (tests/ListStat.hs).
  sym = dontCheck super.sym;

  # 2024-01-24: https://github.com/haskellari/tree-diff/issues/79
  # exprParser fails to parse pretty printed structure correctly when the randomizer uses newlines (?)
  tree-diff = overrideCabal (drv: {
    testFlags = drv.testFlags or [ ] ++ [
      "-p"
      "!/parsec-ansi-wl-pprint/"
    ];
  }) super.tree-diff;

  # base <4.19
  # https://github.com/well-typed/large-records/issues/168
  large-generics = doJailbreak super.large-generics;

  # Too strict bound on bytestring < 0.12
  # https://github.com/raehik/heystone/issues/2
  heystone = doJailbreak super.heystone;

  # Too strict bounds on base, ghc-prim, primitive
  # https://github.com/kowainik/typerep-map/pull/128
  typerep-map = doJailbreak super.typerep-map;

  # Too strict bounds on base
  kewar = doJailbreak super.kewar;

  # Tests rely on (missing) submodule
  unleash-client-haskell-core = dontCheck super.unleash-client-haskell-core;

  # Workaround for Cabal failing to find nonexistent SDL2 library?!
  # https://github.com/NixOS/nixpkgs/issues/260863
  sdl2-gfx = overrideCabal { __propagatePkgConfigDepends = false; } super.sdl2-gfx;

  # Needs git for compile-time insertion of commit hash into --version string.
  kmonad = overrideCabal (drv: {
    libraryToolDepends = (drv.libraryToolDepends or [ ]) ++ [ pkgs.buildPackages.git ];
  }) super.kmonad;

  # 2024-03-17: broken
  vaultenv = dontDistribute super.vaultenv;

  # 2024-01-24: support optparse-applicative 0.18
  niv = appendPatches [
    (fetchpatch {
      # needed for the following patch to apply
      url = "https://github.com/nmattia/niv/commit/7b76374b2b44152bfbf41fcb60162c2ce9182e7a.patch";
      includes = [ "src/*" ];
      hash = "sha256-3xG+GD6fUCGgi2EgS7WUpjfn6gvc2JurJcIrnyy4ys8=";
    })
    (fetchpatch {
      # Update to optparse-applicative 0.18
      url = "https://github.com/nmattia/niv/commit/290965abaa02be33b601032d850c588a6bafb1a5.patch";
      hash = "sha256-YxUdv4r/Fx+8YxHhqEuS9uZR1XKzVCPrLmj5+AY5GRA=";
    })
  ] super.niv;

  # 2024-03-25: HSH broken because of the unix-2.8.0.0 breaking change
  HSH = appendPatches [ ./patches/HSH-unix-openFd.patch ] super.HSH;

  # Support unix < 2.8 to build in older ghc than 9.6
  linux-namespaces = appendPatch (fetchpatch {
    url = "https://github.com/redneb/hs-linux-namespaces/commit/f4a3546541bb6c7172fdd03e177a961da60e3951.patch";
    sha256 = "sha256-6Qv7NWIbzR3ktMGFogw5597bIqPH7Z4hoFvvBQAoquY=";
  }) super.linux-namespaces;

  # Use recent git version as the hackage version is outdated and not building on recent GHC versions
  haskell-to-elm = overrideSrc {
    version = "unstable-2023-12-02";
    src = pkgs.fetchFromGitHub {
      owner = "haskell-to-elm";
      repo = "haskell-to-elm";
      rev = "52ab086a320a14051aa38d0353d957fb6b2525e9";
      hash = "sha256-j6F4WplJy7NyhTAuiDd/tHT+Agk1QdyPjOEkceZSxq8=";
    };
  } super.haskell-to-elm;

  # Overly strict upper bounds on esqueleto
  # https://github.com/jonschoning/espial/issues/61
  espial = doJailbreak super.espial;

  # https://github.com/isovector/type-errors/issues/9
  type-errors = dontCheck super.type-errors;

  # Too strict bounds on text. Can be removed after https://github.com/alx741/currencies/pull/3 is merged
  currencies = doJailbreak super.currencies;

  argon2 = appendPatch (fetchpatch {
    # https://github.com/haskell-hvr/argon2/pull/20
    url = "https://github.com/haskell-hvr/argon2/commit/f7cc92f18e233e6b1dabf1798dd099e17b6a81a1.patch";
    hash = "sha256-JxraFWzErJT4EhELa3PWBGHaLT9OLgEPNSnxwpdpHd0=";
  }) (doJailbreak super.argon2); # Unmaintained

  # 2024-07-09: zinza has bumped their QuickCheck and tasty dependencies beyond stackage lts.
  # Can possibly be removed once QuickCheck >= 2.15 and tasty >= 1.5
  zinza = dontCheck super.zinza;

  pdftotext = overrideCabal (drv: {
    postPatch = ''
      # Fixes https://todo.sr.ht/~geyaeb/haskell-pdftotext/6
      substituteInPlace pdftotext.cabal --replace-quiet c-sources cxx-sources

      # Fix cabal ignoring cxx because the cabal format version is too old
      substituteInPlace pdftotext.cabal --replace-quiet ">=1.10" 2.2

      # Fix wrong license name that breaks recent cabal version
      substituteInPlace pdftotext.cabal --replace-quiet BSD3 BSD-3-Clause
    ''
    + (drv.postPatch or "");
  }) (doJailbreak (addExtraLibrary pkgs.pkg-config (addExtraLibrary pkgs.poppler super.pdftotext)));

  proto3-wire = appendPatch (fetchpatch {
    # https://github.com/awakesecurity/proto3-wire/pull/109
    url = "https://github.com/awakesecurity/proto3-wire/commit/b32f3db6f8d36ea0708fb2f371f62d439ea45b42.patch";
    hash = "sha256-EGFyk3XawU0+zk299WGwFKB2uW9eJrCDM6NgfIKWgRY=";
  }) super.proto3-wire;

  # 2024-07-27: building test component requires non-trivial custom build steps
  # https://github.com/awakesecurity/proto3-suite/blob/bec9d40e2767143deed5b2d451197191f1d8c7d5/nix/overlays/haskell-packages.nix#L311
  proto3-suite = lib.pipe super.proto3-suite [
    dontCheck # Hackage release trails a good deal behind master
    doJailbreak
  ];

  # Tests require docker
  testcontainers = dontCheck super.testcontainers;

  # https://bitbucket.org/echo_rm/hailgun/pull-requests/27
  hailgun = appendPatches [
    (fetchpatch {
      url = "https://bitbucket.org/nh2/hailgun/commits/ac2bc2a3003e4b862625862c4565fece01c0cf57/raw";
      sha256 = "sha256-MWeK9nzMVP6cQs2GBFkohABgL8iWcT7YzwF+tLOkIjo=";
    })
    (fetchpatch {
      url = "https://bitbucket.org/nh2/hailgun/commits/583daaf87265a7fa67ce5171fe1077e61be9b39c/raw";
      sha256 = "sha256-6WITonLoONxZzzkS7EI79LwmwSdkt6TCgvHA2Hwy148=";
    })
    (fetchpatch {
      url = "https://bitbucket.org/nh2/hailgun/commits/b9680b82f6d58f807828c1bbb57e26c7af394501/raw";
      sha256 = "sha256-MnOc51tTNg8+HDu1VS2Ct7Mtu0vuuRd3DjzOAOF+t7Q=";
    })
  ] super.hailgun;

  # opencascade-hs requires the include path configuring relative to the
  # opencascade subdirectory in include.
  opencascade-hs = appendConfigureFlags [
    "--extra-include-dirs=${lib.getDev pkgs.opencascade-occt}/include/opencascade"
  ] super.opencascade-hs;

  # https://github.com/haskell-grpc-native/http2-client/pull/95
  # https://github.com/haskell-grpc-native/http2-client/pull/96
  # https://github.com/haskell-grpc-native/http2-client/pull/97
  # Apply patch for http2 >= 5.2, allow tls >= 2.1 and network >= 3.2
  http2-client = appendPatches [
    (fetchpatch {
      name = "http2-client-fix-build-with-http2-5.3.patch";
      url = "https://github.com/haskell-grpc-native/http2-client/pull/97/commits/95143e4843253913097838ab791ef39ddfd90b33.patch";
      sha256 = "09205ziac59axld8v1cyxa9xl42srypaq8d1gf6y3qwpmrx3rgr9";
    })
  ] (doJailbreak super.http2-client);

  # https://github.com/snoyberg/http-client/pull/563
  http-client-tls = doJailbreak super.http-client-tls;

  # agda2hs 1.3 is not compatible with Agda 2.8.0
  agda2hs = lib.pipe super.agda2hs [
    (warnAfterVersion "1.3")
    (overrideSrc rec {
      version = "1.4";
      src = pkgs.fetchFromGitHub {
        owner = "agda";
        repo = "agda2hs";
        rev = "v${version}";
        hash = "sha256-ZhemGUY6V0cplSwDAXkny+s6yQWKDDShTiUotIDhTXY=";
      };
    })
  ];

  bsb-http-chunked = lib.pipe super.bsb-http-chunked [
    (warnAfterVersion "0.0.0.4")
    # Last released in 2018
    # https://github.com/sjakobi/bsb-http-chunked/issues/38
    # https://github.com/sjakobi/bsb-http-chunked/issues/45
    (overrideSrc {
      src = pkgs.fetchFromGitHub {
        owner = "sjakobi";
        repo = "bsb-http-chunked";
        rev = "c0ecd72fe2beb1cf7de9340cc8b4a31045460532";
        hash = "sha256-+UDxfywXPjxPuFupcB8veyMYWVQCKha64me9HADtFGg=";
      };
    })
    # https://github.com/sjakobi/bsb-http-chunked/pull/49
    (appendPatch (fetchpatch {
      url = "https://github.com/sjakobi/bsb-http-chunked/commit/689bf9ce12b8301d0e13a68e4a515c2779b62947.patch";
      sha256 = "sha256-ZdCXMhni+RGisRODiElObW5c4hKy2giWQmWnatqeRJo=";
    }))
  ];

  # jailbreak to allow deepseq >= 1.5, https://github.com/jumper149/blucontrol/issues/3
  blucontrol = doJailbreak super.blucontrol;

  # Needs to match pandoc, see:
  # https://github.com/jgm/pandoc/commit/97b36ecb7703b434ed4325cc128402a9eb32418d
  commonmark-pandoc = doDistribute self.commonmark-pandoc_0_2_2_3;

  pandoc = lib.pipe super.pandoc [
    dontCheck # test errors in "jats-writer" possibly fixed in newer release
    # Test output changes with newer version of texmath
    (appendPatch (fetchpatch {
      name = "jats:update-for-texmath";
      url = "https://github.com/jgm/pandoc/commit/e2a0cc9ddaf9e7d35cbd3c76f37e39737a79c2bf.patch";
      sha256 = "sha256-qA9mfYS/VhWwYbB9yu7wbHwozz3cqequ361PxkbAt08=";
      includes = [ "test/*" ];
    }))
    (appendPatch (fetchpatch {
      name = "jats:update-for-mathml";
      url = "https://github.com/jgm/pandoc/commit/4ba0bac5c118da4da1d44e3bbb38d7c7aef19e3b.patch";
      sha256 = "sha256-ayRKeCqYKgZVA826xgAXxGhttm0Gx4ZrIRJlFlXPKhw=";
    }))
    (appendPatch (fetchpatch {
      name = "jats:use-texmath-0.12.10.1";
      url = "https://github.com/jgm/pandoc/commit/d3d5366e5197330e035f9f1700929c9b5a24d532.patch";
      sha256 = "sha256-skG7LbKl4ypVnEYA9xMtDbUmHrjuXWfuchV8iMn8Yy0=";
      includes = [ "test/*" ];
    }))
  ];

  HList = lib.pipe super.HList [
    # Fixes syntax error in tests
    (appendPatch (fetchpatch {
      url = "https://bitbucket.org/HList/hlist/commits/e688f11d7432c812c2b238464401a86f588f81e1/raw";
      sha256 = "sha256-XIBIrR2MFmhKaocZJ4p57CgmAaFmMU5Z5a0rk2CjIcM=";
    }))

  ];

  # 2025-04-09: jailbreak to allow hedgehog >= 1.5
  hw-int = warnAfterVersion "0.0.2.0" (doJailbreak super.hw-int);

  # 2025-04-09: jailbreak to allow tasty-quickcheck >= 0.11
  chimera = warnAfterVersion "0.4.1.0" (doJailbreak super.chimera);

  # 2025-04-09: jailbreak to allow tasty-quickcheck >= 0.11
  bzlib = warnAfterVersion "0.5.2.0" (doJailbreak super.bzlib);

  inherit
    (lib.mapAttrs (
      _: pkg:
      lib.pipe pkg [
        (addTestToolDepends (
          with pkgs;
          [
            cvc4
            cvc5
            z3
          ]
        ))
        # 2025-04-09: FIXME: template_tests still failing with:
        #   fd:9: hPutBuf: resource vanished (Broken pipe)
        dontCheck

        doDistribute
      ]
    ) super)
    what4
    what4_1_7
    ;

  copilot-theorem = lib.pipe super.copilot-theorem [
    (addTestToolDepends (with pkgs; [ z3 ]))
  ];

  # 2025-04-09: jailbreak to allow mtl >= 2.3, template-haskell >= 2.17, text >= 1.3
  egison-pattern-src-th-mode = warnAfterVersion "0.2.1.2" (
    doJailbreak super.egison-pattern-src-th-mode
  );

  # 2025-04-09: jailbreak to allow base >= 4.17, hasql >= 1.6, hasql-transaction-io >= 0.2
  hasql-streams-core = warnAfterVersion "0.1.0.0" (doJailbreak super.hasql-streams-core);

  # 2025-04-09: jailbreak to allow bytestring >= 0.12, text >= 2.1
  pipes-text = warnAfterVersion "1.0.1" (doJailbreak super.pipes-text);

  # 2025-04-09: jailbreak to allow bytestring >= 0.12
  array-builder = warnAfterVersion "0.1.4.1" (doJailbreak super.array-builder);

  # 2025-04-09: missing dependency - somehow it's not listed on hackage
  broadcast-chan = addExtraLibrary self.conduit super.broadcast-chan;

  # 2025-04-09: jailbreak to allow template-haskell >= 2.21, th-abstraction >= 0.7
  kind-generics-th = warnAfterVersion "0.2.3.3" (doJailbreak super.kind-generics-th);

  # 2025-04-09: jailbreak to allow tasty >= 1.5
  cvss = warnAfterVersion "0.1" (doJailbreak super.cvss);

  # 2025-04-09: jailbreak to allow aeson >= 2.2, base >= 4.19, text >= 2.1
  ebird-api = warnAfterVersion "0.2.0.0" (doJailbreak super.ebird-api);

  # 2025-04-13: jailbreak to allow bytestring >= 0.12
  strings = warnAfterVersion "1.1" (doJailbreak super.strings);

  # 2025-04-13: jailbreak to allow bytestring >= 0.12
  twain = warnAfterVersion "2.2.0.1" (doJailbreak super.twain);

  # 2025-04-13: jailbreak to allow hedgehog >= 1.5
  hw-bits = warnAfterVersion "0.7.2.2" (doJailbreak super.hw-bits);

  # 2025-04-23: jailbreak to allow bytestring >= 0.12
  brillo-rendering = warnAfterVersion "1.13.3" (doJailbreak super.brillo-rendering);
  brillo-examples = warnAfterVersion "1.13.3" (doJailbreak super.brillo-examples);
  brillo-juicy = warnAfterVersion "0.2.4" (doJailbreak super.brillo-juicy);
  brillo = warnAfterVersion "1.13.3" (doJailbreak super.brillo);

  # Floating point precision issues. Test suite is only checked on x86_64.
  # https://github.com/tweag/monad-bayes/issues/368
  monad-bayes = dontCheckIf (
    let
      inherit (pkgs.stdenv) hostPlatform;
    in
    !hostPlatform.isx86_64
    # Presumably because we emulate x86_64-darwin via Rosetta, x86_64-darwin
    # also fails on Hydra
    || hostPlatform.isDarwin
  ) super.monad-bayes;

  # 2025-04-13: jailbreak to allow th-abstraction >= 0.7
  crucible = warnAfterVersion "0.7.2" (
    doJailbreak (
      super.crucible.override {
        what4 = self.what4_1_7;
      }
    )
  );

  crucible-llvm = super.crucible-llvm.override {
    what4 = self.what4_1_7;
  };

  # Test suite invokes cabal-install in a way incompatible with our generic builder
  # (i.e. tries to re-use the ghc package db / environment from dist-newstyle).
  sensei = dontCheck super.sensei;

  crux = super.crux.override {
    simple-get-opt = self.simple-get-opt_0_4;
  };

  # 2025-04-23: jailbreak to allow megaparsec >= 9.7
  # 2025-04-23: test data missing from tarball
  crucible-syntax = doJailbreak (dontCheck super.crucible-syntax);
  # 2025-04-23: missing test data
  crucible-debug = overrideCabal (drv: {
    testFlags = drv.testFlags or [ ] ++ [
      "-p"
      (lib.concatStringsSep "&&" [
        "!/backtrace.txt/"
        "!/block.txt/"
        "!/call-basic.txt/"
        "!/clear.txt/"
        "!/frame.txt/"
        "!/load-empty.txt/"
        "!/obligation-false.txt/"
        "!/prove-false.txt/"
        "!/prove-true.txt/"
        "!/test-data\\/.break.txt/"
        "!/test-data\\/.reg.txt/"
        "!/test-data\\/.reg.txt/"
        "!/test-data\\/.trace.txt/"
        "!/test-data\\/complete\\/.break.txt/"
      ])
    ];
  }) super.crucible-debug;
  # 2025-04-23: missing test data
  llvm-pretty-bc-parser = dontCheck super.llvm-pretty-bc-parser;

  # 2025-04-23: Allow bytestring >= 0.12
  # https://github.com/mrkkrp/wave/issues/48
  wave = doJailbreak super.wave;

  # 2025-04-23: disable bounds microlens <0.5, QuickCheck < 2.16
  # https://github.com/debug-ito/wild-bind/issues/7
  wild-bind = doJailbreak super.wild-bind;

  # Test suite no longer compiles with hspec-hedgehog >= 0.3
  finitary = dontCheck super.finitary;

  # 2025-04-13: jailbreak to allow bytestring >= 0.12, text >= 2.1
  ktx-codec = warnAfterVersion "0.0.2.1" (doJailbreak super.ktx-codec);

  # 2025-04-13: jailbreak to allow template-haskell >= 2.17
  sr-extra = warnAfterVersion "1.88" (
    overrideCabal (drv: {
      version = "1.88-unstable-2025-03-30";
      # includes https://github.com/seereason/sr-extra/pull/7
      src = pkgs.fetchFromGitHub {
        owner = "seereason";
        repo = "sr-extra";
        rev = "2b18ced8d07aa8832168971842b20ea49369e4f0";
        hash = "sha256-jInfHA1xkLjx5PfsgQVzeQIN3OjTUpEz7dpVNOGNo3g=";
      };
      editedCabalFile = null;
      revision = null;
    }) super.sr-extra
  );

  # Too strict bounds on base <4.19 and tasty <1.5
  # https://github.com/maoe/ghc-prof/issues/25
  ghc-prof = doJailbreak super.ghc-prof;
  # aeson <2.2, bytestring <0.12, text <2.1
  # https://github.com/jaspervdj/profiteur/issues/43
  profiteur = doJailbreak super.profiteur;

  # 2025-04-19: Tests randomly fail 6 out of 10 times
  coinor-clp = dontCheck super.coinor-clp;

  # 2025-04-19: Tests randomly fail 5 out of 10 times
  fft = dontCheck super.fft;

  # 2025-5-15: Too strict bounds on base <4.19, see: https://github.com/zachjs/sv2v/issues/317
  sv2v = doJailbreak super.sv2v;

  # 2025-06-25: Upper bounds of transformers and bytestring too strict,
  # as haskore 0.2.0.8 was released in 2016 and is quite outdated.
  # Tests fail with:
  #   ### Error in:   11:comparison with MIDI files generated by former Haskore versions:23:Ssf:1
  #   src/Test/MIDI/Ssf.mid: openBinaryFile: does not exist (No such file or directory)
  # Necessary files aren't listed in extra-source-files in the cabal file
  # and therefore aren't uploaded to hackage
  # Needs to be fixed upstream
  haskore = dontCheck (doJailbreak super.haskore);

  # 2025-08-01: Fixes few build errors related to pointers.
  # https://github.com/haskell-cryptography/botan/pull/17
  botan-bindings = appendPatch (pkgs.fetchpatch2 {
    url = "https://github.com/haskell-cryptography/botan/commit/99de68c3938187b7ab740c6534ec032a4a236747.patch";
    sha256 = "sha256-v255WFO9HsRuTAWFZG27TYbpoK7rJ1AuiCFNFIV18mI=";
    stripLen = 1;
  }) super.botan-bindings;

  # 2025-08-04: Disable failing testcases. It would feel bad to disable all the
  # checks in a cryptography related package.
  botan-low = overrideCabal (drv: {
    testFlags =
      drv.testFlags or [ ]
      ++ (lib.concatMap (x: [ "--skip" ] ++ [ x ]) [
        # botan-low-cipher-tests
        "/AES-128/SIV/can incrementally / online encipher a message/"
        "/AES-128/SIV/can incrementally / online decipher a message/"
        "/AES-128/SIV/has parity between online and offline/"
        "/AES-192/SIV/can incrementally / online encipher a message/"
        "/AES-192/SIV/can incrementally / online decipher a message/"
        "/AES-192/SIV/has parity between online and offline/"
        "/AES-256/SIV/can incrementally / online encipher a message/"
        "/AES-256/SIV/can incrementally / online decipher a message/"
        "/AES-256/SIV/has parity between online and offline/"
        "/ARIA-128/SIV/can incrementally / online encipher a message/"
        "/ARIA-128/SIV/can incrementally / online decipher a message/"
        "/ARIA-128/SIV/has parity between online and offline/"
        "/ARIA-192/SIV/can incrementally / online encipher a message/"
        "/ARIA-192/SIV/can incrementally / online decipher a message/"
        "/ARIA-192/SIV/has parity between online and offline/"
        "/ARIA-256/SIV/can incrementally / online encipher a message/"
        "/ARIA-256/SIV/can incrementally / online decipher a message/"
        "/ARIA-256/SIV/has parity between online and offline/"
        "/Camellia-128/SIV/can incrementally / online encipher a message/"
        "/Camellia-128/SIV/can incrementally / online decipher a message/"
        "/Camellia-128/SIV/has parity between online and offline/"
        "/Camellia-192/SIV/can incrementally / online encipher a message/"
        "/Camellia-192/SIV/can incrementally / online decipher a message/"
        "/Camellia-192/SIV/has parity between online and offline/"
        "/Camellia-256/SIV/can incrementally / online encipher a message/"
        "/Camellia-256/SIV/can incrementally / online decipher a message/"
        "/Camellia-256/SIV/has parity between online and offline/"
        "/Noekeon/SIV/can incrementally / online encipher a message/"
        "/Noekeon/SIV/can incrementally / online decipher a message/"
        "/Noekeon/SIV/has parity between online and offline/"
        "/SEED/SIV/can incrementally / online encipher a message/"
        "/SEED/SIV/can incrementally / online decipher a message/"
        "/SEED/SIV/has parity between online and offline/"
        "/SM4/SIV/can incrementally / online encipher a message/"
        "/SM4/SIV/can incrementally / online decipher a message/"
        "/SM4/SIV/has parity between online and offline/"
        "/Serpent/SIV/can incrementally / online encipher a message/"
        "/Serpent/SIV/can incrementally / online decipher a message/"
        "/Serpent/SIV/has parity between online and offline/"
        "/Twofish/SIV/can incrementally / online encipher a message/"
        "/Twofish/SIV/can incrementally / online decipher a message/"
        "/Twofish/SIV/has parity between online and offline/"
        "/AES-128/CCM/can incrementally / online encipher a message/"
        "/AES-128/CCM/can incrementally / online decipher a message/"
        "/AES-128/CCM/has parity between online and offline/"
        "/AES-192/CCM/can incrementally / online encipher a message/"
        "/AES-192/CCM/can incrementally / online decipher a message/"
        "/AES-192/CCM/has parity between online and offline/"
        "/AES-256/CCM/can incrementally / online encipher a message/"
        "/AES-256/CCM/can incrementally / online decipher a message/"
        "/AES-256/CCM/has parity between online and offline/"
        "/ARIA-128/CCM/can incrementally / online encipher a message/"
        "/ARIA-128/CCM/can incrementally / online decipher a message/"
        "/ARIA-128/CCM/has parity between online and offline/"
        "/ARIA-192/CCM/can incrementally / online encipher a message/"
        "/ARIA-192/CCM/can incrementally / online decipher a message/"
        "/ARIA-192/CCM/has parity between online and offline/"
        "/ARIA-256/CCM/can incrementally / online encipher a message/"
        "/ARIA-256/CCM/can incrementally / online decipher a message/"
        "/ARIA-256/CCM/has parity between online and offline/"
        "/Camellia-128/CCM/can incrementally / online encipher a message/"
        "/Camellia-128/CCM/can incrementally / online decipher a message/"
        "/Camellia-128/CCM/has parity between online and offline/"
        "/Camellia-192/CCM/can incrementally / online encipher a message/"
        "/Camellia-192/CCM/can incrementally / online decipher a message/"
        "/Camellia-192/CCM/has parity between online and offline/"
        "/Camellia-256/CCM/can incrementally / online encipher a message/"
        "/Camellia-256/CCM/can incrementally / online decipher a message/"
        "/Camellia-256/CCM/has parity between online and offline/"
        "/Noekeon/CCM/can incrementally / online encipher a message/"
        "/Noekeon/CCM/can incrementally / online decipher a message/"
        "/Noekeon/CCM/has parity between online and offline/"
        "/SEED/CCM/can incrementally / online encipher a message/"
        "/SEED/CCM/can incrementally / online decipher a message/"
        "/SEED/CCM/has parity between online and offline/"
        "/SM4/CCM/can incrementally / online encipher a message/"
        "/SM4/CCM/can incrementally / online decipher a message/"
        "/SM4/CCM/has parity between online and offline/"
        "/Serpent/CCM/can incrementally / online encipher a message/"
        "/Serpent/CCM/can incrementally / online decipher a message/"
        "/Serpent/CCM/has parity between online and offline/"
        "/Twofish/CCM/can incrementally / online encipher a message/"
        "/Twofish/CCM/can incrementally / online decipher a message/"
        "/Twofish/CCM/has parity between online and offline/"
        # botan-low-mpi-tests
        "/can compute the modular inverse/"
        # botan-low-pubkey-dsa-tests
        "/modp/srp/1024/privKeyLoadDSA/"
        "/modp/srp/1024/pubKeyLoadDSA/"
        "/modp/srp/1536/privKeyLoadDSA/"
        "/modp/srp/1536/pubKeyLoadDSA/"
        "/modp/srp/2048/privKeyLoadDSA/"
        "/modp/srp/2048/pubKeyLoadDSA/"
        "/modp/srp/3072/privKeyLoadDSA/"
        "/modp/srp/3072/pubKeyLoadDSA/"
        "/modp/srp/4096/privKeyLoadDSA/"
        "/modp/srp/4096/pubKeyLoadDSA/"
        "/modp/srp/6144/privKeyLoadDSA/"
        "/modp/srp/6144/pubKeyLoadDSA/"
        "/modp/srp/8192/privKeyLoadDSA/"
        "/modp/srp/8192/pubKeyLoadDSA/"
        # botan-low-pubkey-decrypt-tests
        "/SM2 sm2p256v1 SHA-256/decrypt/"
        # botan-low-pubkey-encrypt-tests
        "/SM2 sm2p256v1 SHA-256/encrypt/"
        # botan-low-pwdhash-tests
        "/Scrypt/pwdhashTimed/"
        # botan-low-srp6-tests
        "/ffdhe/ietf/2048/can negotiate a shared secret/"
        "/ffdhe/ietf/3072/can negotiate a shared secret/"
        "/ffdhe/ietf/4096/can negotiate a shared secret/"
        "/ffdhe/ietf/6144/can negotiate a shared secret/"
        "/ffdhe/ietf/8192/can negotiate a shared secret/"
        "/modp/ietf/1024/can negotiate a shared secret/"
        "/modp/ietf/1536/can negotiate a shared secret/"
        "/modp/ietf/2048/can negotiate a shared secret/"
        "/modp/ietf/3072/can negotiate a shared secret/"
        "/modp/ietf/4096/can negotiate a shared secret/"
        "/modp/ietf/6144/can negotiate a shared secret/"
        "/modp/ietf/8192/can negotiate a shared secret/"
        "/modp/srp/1024/can negotiate a shared secret/"
        "/modp/srp/1536/can negotiate a shared secret/"
        "/modp/srp/2048/can negotiate a shared secret/"
        "/modp/srp/3072/can negotiate a shared secret/"
        "/modp/srp/4096/can negotiate a shared secret/"
        "/modp/srp/6144/can negotiate a shared secret/"
        "/modp/srp/8192/can negotiate a shared secret/"
        "/dsa/jce/1024/can negotiate a shared secret/"
        "/dsa/botan/2048/can negotiate a shared secret/"
        "/dsa/botan/3072/can negotiate a shared secret/"
      ]);
  }) super.botan-low;
}
// import ./configuration-tensorflow.nix { inherit pkgs haskellLib; } self super

# Amazonka Packages
# 2025-01-24: use latest source files from github, as the hackage release is outdated, https://github.com/brendanhay/amazonka/issues/1001
// (
  let
    amazonkaSrc = pkgs.fetchFromGitHub {
      owner = "brendanhay";
      repo = "amazonka";
      rev = "f3a7fca02fdbb832cc348e991983b1465225d50c";
      sha256 = "sha256-u+R+4WeCd16X8H2dkDHzD3nOLsvsTB0lLNUsbRT23aE=";
    };
    setAmazonkaSourceRoot =
      dir: drv:
      (overrideSrc {
        version = "2.0";
        src = amazonkaSrc + "/${dir}";
      })
        drv;
    # To get the list of amazonka services run:
    # > nix eval --impure --expr 'builtins.attrNames (import ./. {}).haskellPackages' --json | jq '.[]' | grep '^"amazonka'
    # NB: we exclude amazonka-test and amazonka-s3-streaming
    amazonkaServices = [
      "amazonka"
      "amazonka-accessanalyzer"
      "amazonka-account"
      "amazonka-alexa-business"
      "amazonka-amp"
      "amazonka-amplify"
      "amazonka-amplifybackend"
      "amazonka-amplifyuibuilder"
      "amazonka-apigateway"
      "amazonka-apigatewaymanagementapi"
      "amazonka-apigatewayv2"
      "amazonka-appconfig"
      "amazonka-appconfigdata"
      "amazonka-appflow"
      "amazonka-appintegrations"
      "amazonka-application-autoscaling"
      "amazonka-application-insights"
      "amazonka-applicationcostprofiler"
      "amazonka-appmesh"
      "amazonka-apprunner"
      "amazonka-appstream"
      "amazonka-appsync"
      "amazonka-arc-zonal-shift"
      "amazonka-athena"
      "amazonka-auditmanager"
      "amazonka-autoscaling"
      "amazonka-autoscaling-plans"
      "amazonka-backup"
      "amazonka-backup-gateway"
      "amazonka-backupstorage"
      "amazonka-batch"
      "amazonka-billingconductor"
      "amazonka-braket"
      "amazonka-budgets"
      "amazonka-certificatemanager"
      "amazonka-certificatemanager-pca"
      "amazonka-chime"
      "amazonka-chime-sdk-identity"
      "amazonka-chime-sdk-media-pipelines"
      "amazonka-chime-sdk-meetings"
      "amazonka-chime-sdk-messaging"
      "amazonka-chime-sdk-voice"
      "amazonka-cloud9"
      "amazonka-cloudcontrol"
      "amazonka-clouddirectory"
      "amazonka-cloudformation"
      "amazonka-cloudfront"
      "amazonka-cloudhsm"
      "amazonka-cloudhsmv2"
      "amazonka-cloudsearch"
      "amazonka-cloudsearch-domains"
      "amazonka-cloudtrail"
      "amazonka-cloudwatch"
      "amazonka-cloudwatch-events"
      "amazonka-cloudwatch-logs"
      "amazonka-codeartifact"
      "amazonka-codebuild"
      "amazonka-codecommit"
      "amazonka-codedeploy"
      "amazonka-codeguru-reviewer"
      "amazonka-codeguruprofiler"
      "amazonka-codepipeline"
      "amazonka-codestar"
      "amazonka-codestar-connections"
      "amazonka-codestar-notifications"
      "amazonka-cognito-identity"
      "amazonka-cognito-idp"
      "amazonka-cognito-sync"
      "amazonka-comprehend"
      "amazonka-comprehendmedical"
      "amazonka-compute-optimizer"
      "amazonka-config"
      "amazonka-connect"
      "amazonka-connect-contact-lens"
      "amazonka-connectcampaigns"
      "amazonka-connectcases"
      "amazonka-connectparticipant"
      "amazonka-contrib-rds-utils"
      "amazonka-controltower"
      "amazonka-core"
      "amazonka-cost-explorer"
      "amazonka-cur"
      "amazonka-customer-profiles"
      "amazonka-databrew"
      "amazonka-dataexchange"
      "amazonka-datapipeline"
      "amazonka-datasync"
      "amazonka-detective"
      "amazonka-devicefarm"
      "amazonka-devops-guru"
      "amazonka-directconnect"
      "amazonka-discovery"
      "amazonka-dlm"
      "amazonka-dms"
      "amazonka-docdb"
      "amazonka-docdb-elastic"
      "amazonka-drs"
      "amazonka-ds"
      "amazonka-dynamodb"
      "amazonka-dynamodb-dax"
      "amazonka-dynamodb-streams"
      "amazonka-ebs"
      "amazonka-ec2"
      "amazonka-ec2-instance-connect"
      "amazonka-ecr"
      "amazonka-ecr-public"
      "amazonka-ecs"
      "amazonka-efs"
      "amazonka-eks"
      "amazonka-elastic-inference"
      "amazonka-elasticache"
      "amazonka-elasticbeanstalk"
      "amazonka-elasticsearch"
      "amazonka-elastictranscoder"
      "amazonka-elb"
      "amazonka-elbv2"
      "amazonka-emr"
      "amazonka-emr-containers"
      "amazonka-emr-serverless"
      "amazonka-evidently"
      "amazonka-finspace"
      "amazonka-finspace-data"
      "amazonka-fis"
      "amazonka-fms"
      "amazonka-forecast"
      "amazonka-forecastquery"
      "amazonka-frauddetector"
      "amazonka-fsx"
      "amazonka-gamelift"
      "amazonka-gamesparks"
      "amazonka-glacier"
      "amazonka-globalaccelerator"
      "amazonka-glue"
      "amazonka-grafana"
      "amazonka-greengrass"
      "amazonka-greengrassv2"
      "amazonka-groundstation"
      "amazonka-guardduty"
      "amazonka-health"
      "amazonka-healthlake"
      "amazonka-honeycode"
      "amazonka-iam"
      "amazonka-iam-policy"
      "amazonka-identitystore"
      "amazonka-imagebuilder"
      "amazonka-importexport"
      "amazonka-inspector"
      "amazonka-inspector2"
      "amazonka-iot"
      "amazonka-iot-analytics"
      "amazonka-iot-dataplane"
      "amazonka-iot-jobs-dataplane"
      "amazonka-iot-roborunner"
      "amazonka-iot1click-devices"
      "amazonka-iot1click-projects"
      "amazonka-iotdeviceadvisor"
      "amazonka-iotevents"
      "amazonka-iotevents-data"
      "amazonka-iotfleethub"
      "amazonka-iotfleetwise"
      "amazonka-iotsecuretunneling"
      "amazonka-iotsitewise"
      "amazonka-iotthingsgraph"
      "amazonka-iottwinmaker"
      "amazonka-iotwireless"
      "amazonka-ivs"
      "amazonka-ivschat"
      "amazonka-kafka"
      "amazonka-kafkaconnect"
      "amazonka-kendra"
      "amazonka-keyspaces"
      "amazonka-kinesis"
      "amazonka-kinesis-analytics"
      "amazonka-kinesis-firehose"
      "amazonka-kinesis-video"
      "amazonka-kinesis-video-archived-media"
      "amazonka-kinesis-video-media"
      "amazonka-kinesis-video-signaling"
      "amazonka-kinesis-video-webrtc-storage"
      "amazonka-kinesisanalyticsv2"
      "amazonka-kms"
      "amazonka-lakeformation"
      "amazonka-lambda"
      "amazonka-lex-models"
      "amazonka-lex-runtime"
      "amazonka-lexv2-models"
      "amazonka-license-manager"
      "amazonka-license-manager-linux-subscriptions"
      "amazonka-license-manager-user-subscriptions"
      "amazonka-lightsail"
      "amazonka-location"
      "amazonka-lookoutequipment"
      "amazonka-lookoutmetrics"
      "amazonka-lookoutvision"
      "amazonka-m2"
      "amazonka-macie"
      "amazonka-maciev2"
      "amazonka-managedblockchain"
      "amazonka-marketplace-analytics"
      "amazonka-marketplace-catalog"
      "amazonka-marketplace-entitlement"
      "amazonka-marketplace-metering"
      "amazonka-mechanicalturk"
      "amazonka-mediaconnect"
      "amazonka-mediaconvert"
      "amazonka-medialive"
      "amazonka-mediapackage"
      "amazonka-mediapackage-vod"
      "amazonka-mediastore"
      "amazonka-mediastore-dataplane"
      "amazonka-mediatailor"
      "amazonka-memorydb"
      "amazonka-mgn"
      "amazonka-migration-hub-refactor-spaces"
      "amazonka-migrationhub"
      "amazonka-migrationhub-config"
      "amazonka-migrationhuborchestrator"
      "amazonka-migrationhubstrategy"
      "amazonka-ml"
      "amazonka-mobile"
      "amazonka-mq"
      "amazonka-mtl"
      "amazonka-mwaa"
      "amazonka-neptune"
      "amazonka-network-firewall"
      "amazonka-networkmanager"
      "amazonka-nimble"
      "amazonka-oam"
      "amazonka-omics"
      "amazonka-opensearch"
      "amazonka-opensearchserverless"
      "amazonka-opsworks"
      "amazonka-opsworks-cm"
      "amazonka-organizations"
      "amazonka-outposts"
      "amazonka-panorama"
      "amazonka-personalize"
      "amazonka-personalize-events"
      "amazonka-personalize-runtime"
      "amazonka-pi"
      "amazonka-pinpoint"
      "amazonka-pinpoint-email"
      "amazonka-pinpoint-sms-voice"
      "amazonka-pinpoint-sms-voice-v2"
      "amazonka-pipes"
      "amazonka-polly"
      "amazonka-pricing"
      "amazonka-privatenetworks"
      "amazonka-proton"
      "amazonka-qldb"
      "amazonka-qldb-session"
      "amazonka-quicksight"
      "amazonka-ram"
      "amazonka-rbin"
      "amazonka-rds"
      "amazonka-rds-data"
      "amazonka-redshift"
      "amazonka-redshift-data"
      "amazonka-redshift-serverless"
      "amazonka-rekognition"
      "amazonka-resiliencehub"
      "amazonka-resource-explorer-v2"
      "amazonka-resourcegroups"
      "amazonka-resourcegroupstagging"
      "amazonka-robomaker"
      "amazonka-rolesanywhere"
      "amazonka-route53"
      "amazonka-route53-autonaming"
      "amazonka-route53-domains"
      "amazonka-route53-recovery-cluster"
      "amazonka-route53-recovery-control-config"
      "amazonka-route53-recovery-readiness"
      "amazonka-route53resolver"
      "amazonka-rum"
      "amazonka-s3"
      "amazonka-s3-encryption"
      #"amazonka-s3-streaming"
      "amazonka-s3outposts"
      "amazonka-sagemaker"
      "amazonka-sagemaker-a2i-runtime"
      "amazonka-sagemaker-edge"
      "amazonka-sagemaker-featurestore-runtime"
      "amazonka-sagemaker-geospatial"
      "amazonka-sagemaker-metrics"
      "amazonka-sagemaker-runtime"
      "amazonka-savingsplans"
      "amazonka-scheduler"
      "amazonka-schemas"
      "amazonka-sdb"
      "amazonka-secretsmanager"
      "amazonka-securityhub"
      "amazonka-securitylake"
      "amazonka-serverlessrepo"
      "amazonka-service-quotas"
      "amazonka-servicecatalog"
      "amazonka-servicecatalog-appregistry"
      "amazonka-ses"
      "amazonka-sesv2"
      "amazonka-shield"
      "amazonka-signer"
      "amazonka-simspaceweaver"
      "amazonka-sms"
      "amazonka-sms-voice"
      "amazonka-snow-device-management"
      "amazonka-snowball"
      "amazonka-sns"
      "amazonka-sqs"
      "amazonka-ssm"
      "amazonka-ssm-contacts"
      "amazonka-ssm-incidents"
      "amazonka-ssm-sap"
      "amazonka-sso"
      "amazonka-sso-admin"
      "amazonka-sso-oidc"
      "amazonka-stepfunctions"
      "amazonka-storagegateway"
      "amazonka-sts"
      "amazonka-support"
      "amazonka-support-app"
      "amazonka-swf"
      "amazonka-synthetics"
      #"amazonka-test"
      "amazonka-textract"
      "amazonka-timestream-query"
      "amazonka-timestream-write"
      "amazonka-transcribe"
      "amazonka-transfer"
      "amazonka-translate"
      "amazonka-voice-id"
      "amazonka-waf"
      "amazonka-waf-regional"
      "amazonka-wafv2"
      "amazonka-wellarchitected"
      "amazonka-wisdom"
      "amazonka-workdocs"
      "amazonka-worklink"
      "amazonka-workmail"
      "amazonka-workmailmessageflow"
      "amazonka-workspaces"
      "amazonka-workspaces-web"
      "amazonka-xray"
    ];
    amazonkaServiceOverrides = (
      lib.genAttrs amazonkaServices (
        name:
        lib.pipe super.${name} [
          (setAmazonkaSourceRoot "lib/services/${name}")
          (x: x)
        ]
      )
    );
  in
  amazonkaServiceOverrides
  // {
    amazonka-core = lib.pipe super.amazonka-core [
      (warnAfterVersion "2.0")
      (setAmazonkaSourceRoot "lib/amazonka-core")
      (addBuildDepends [
        self.microlens
        self.microlens-contra
        self.microlens-pro
      ])
    ];
    amazonka = warnAfterVersion "2.0" (
      setAmazonkaSourceRoot "lib/amazonka" (doJailbreak super.amazonka)
    );
  }
)
