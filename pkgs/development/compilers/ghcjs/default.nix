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

, ghc, gmp
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

, ghcjsBoot ? import ./ghcjs-boot.nix { inherit fetchgit runCommand; }
, shims ? import ./shims.nix { inherit fetchFromGitHub; }
}:
let version = "0.2.0"; in
mkDerivation (rec {
  pname = "ghcjs";
  inherit version;
  src = fetchFromGitHub {
    owner = "ghcjs";
    repo = "ghcjs";
    rev = "561365ba1667053b5dc5846e2a8edb33eaa3f6dd";
    sha256 = "1vfa7j0ql3sng29m944iznjw9hcmyl57nfkgxa33dvi2ival8dl2";
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
    PATH=$out/bin:$PATH LD_LIBRARY_PATH=${gmp}/lib:${stdenv.cc}/lib64:$LD_LIBRARY_PATH \
      env -u GHC_PACKAGE_PATH $out/bin/ghcjs-boot \
        --dev \
        --quick \
        --with-cabal ${cabal-install}/bin/cabal \
        --with-gmp-includes ${gmp}/include \
        --with-gmp-libraries ${gmp}/lib
  '';
  passthru = {
    isGhcjs = true;
    nativeGhc = ghc;
    inherit nodejs ghcjsBoot;
  };

  homepage = "https://github.com/ghcjs/ghcjs";
  description = "A Haskell to JavaScript compiler that uses the GHC API";
  license = stdenv.lib.licenses.bsd3;
  platforms = ghc.meta.platforms;
  maintainers = with stdenv.lib.maintainers; [ jwiegley cstrahan ];
})
