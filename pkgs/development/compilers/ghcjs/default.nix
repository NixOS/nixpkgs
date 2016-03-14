{ mkDerivation
, test-framework
, test-framework-hunit
, test-framework-quickcheck2
, data-default
, ghc-paths
, haskell-src-exts
, haskell-src-meta
, optparse-applicative
, system-fileio
, system-filepath
, text-binary
, unordered-containers
, cabal-install
, wl-pprint-text
, base16-bytestring
, executable-path
, transformers-compat
, haddock-api
, ghcjs-prim
, regex-posix

, bootPkgs, gmp
, jailbreak-cabal

, runCommand
, nodejs, stdenv, filepath, HTTP, HUnit, mtl, network, QuickCheck, random, stm
, time
, zlib, aeson, attoparsec, bzlib, hashable
, lens
, parallel, safe, shelly, split, stringsearch, syb
, tar, terminfo
, vector, yaml, fetchgit, fetchFromGitHub, Cabal
, alex, happy, git, gnumake, autoconf, patch
, automake, libtool
, cryptohash
, haddock, hspec, xhtml, primitive, cacert, pkgs
, coreutils
, libiconv

, ghcjsBootSrc ? fetchgit {
    url = git://github.com/ghcjs/ghcjs-boot.git;
    rev = "97dea5c4145bf80a1e7cffeb1ecd4d0ecacd5a2f";
    sha256 = "1cgjzm595l2dx6fibzbkyv23bp1857qia0hb9d8aghf006al558j";
    fetchSubmodules = true;
  }
, ghcjsBoot ? import ./ghcjs-boot.nix {
    inherit runCommand;
    src = ghcjsBootSrc;
  }
, shims ? import ./shims.nix { inherit fetchFromGitHub; }
}:
let
  inherit (bootPkgs) ghc;
  version = "0.2.0";

in mkDerivation (rec {
  pname = "ghcjs";
  inherit version;
  src = fetchFromGitHub {
    owner = "ghcjs";
    repo = "ghcjs";
    rev = "13a99c6da40e3700e070e430d4c0f2ea96217b24";
    sha256 = "01yg6babmhn2bfbmgkddisfj9ai7fc4r08s6acd49s9amcw7g5ld";
  };
  isLibrary = true;
  isExecutable = true;
  jailbreak = true;
  doHaddock = false;
  doCheck = false;
  buildDepends = [
    filepath HTTP mtl network random stm time zlib aeson attoparsec
    bzlib data-default ghc-paths hashable haskell-src-exts haskell-src-meta
    lens optparse-applicative parallel safe shelly split
    stringsearch syb system-fileio system-filepath tar terminfo text-binary
    unordered-containers vector wl-pprint-text yaml
    alex happy git gnumake autoconf automake libtool patch gmp
    base16-bytestring cryptohash executable-path haddock-api
    transformers-compat QuickCheck haddock hspec xhtml
    ghcjs-prim regex-posix libiconv
  ];
  buildTools = [ nodejs git ];
  testDepends = [
    HUnit test-framework test-framework-hunit
  ];
  patches = [ ./ghcjs.patch ];
  postPatch = ''
    substituteInPlace Setup.hs \
      --replace "/usr/bin/env" "${coreutils}/bin/env"

    substituteInPlace src/Compiler/Info.hs \
      --replace "@PREFIX@" "$out"          \
      --replace "@VERSION@" "${version}"

    substituteInPlace src-bin/Boot.hs \
      --replace "@PREFIX@" "$out"     \
      --replace "@CC@"     "${stdenv.cc}/bin/cc"
  '';
  preBuild = ''
    local topDir=$out/lib/ghcjs-${version}
    mkdir -p $topDir

    cp -r ${ghcjsBoot} $topDir/ghcjs-boot
    chmod -R u+w $topDir/ghcjs-boot

    cp -r ${shims} $topDir/shims
    chmod -R u+w $topDir/shims

    # Make the patches be relative their corresponding package's directory.
    # See: https://github.com/ghcjs/ghcjs-boot/pull/12
    for patch in "$topDir/ghcjs-boot/patches/"*.patch; do
      echo "fixing patch: $patch"
      sed -i -e 's@ \(a\|b\)/boot/[^/]\+@ \1@g' $patch
    done
  '';
  # We build with --quick so we can build stage 2 packages separately.
  # This is necessary due to: https://github.com/haskell/cabal/commit/af19fb2c2d231d8deff1cb24164a2bf7efb8905a
  # Cabal otherwise fails to build: http://hydra.nixos.org/build/31824079/nixlog/1/raw
  postInstall = ''
    PATH=$out/bin:$PATH LD_LIBRARY_PATH=${gmp.out}/lib:${stdenv.cc}/lib64:$LD_LIBRARY_PATH \
      env -u GHC_PACKAGE_PATH $out/bin/ghcjs-boot \
        --dev \
        --quick \
        --with-cabal ${cabal-install}/bin/cabal \
        --with-gmp-includes ${gmp.dev}/include \
        --with-gmp-libraries ${gmp.out}/lib
  '';
  passthru = let
    ghcjsNodePkgs = pkgs.nodePackages.override {
      generated = ./node-packages-generated.nix;
      self = ghcjsNodePkgs;
    };
  in {
    inherit bootPkgs;
    isCross = true;
    isGhcjs = true;
    inherit nodejs ghcjsBoot;
    inherit (ghcjsNodePkgs) "socket.io";
  };

  homepage = "https://github.com/ghcjs/ghcjs";
  description = "A Haskell to JavaScript compiler that uses the GHC API";
  license = stdenv.lib.licenses.bsd3;
  platforms = ghc.meta.platforms;
  maintainers = with stdenv.lib.maintainers; [ jwiegley cstrahan ];
})
