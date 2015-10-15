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
}:
let
  version = "0.1.0";
  ghcjsBoot = fetchgit {
    url = "git://github.com/ghcjs/ghcjs-boot.git";
    rev = "ec9f795b42b40fd24933d1672db153df5a29cc00"; # master branch
    sha256 = "0bkvqlsgb9n0faayi4k1dlkn9cbm99a66m9nnx1kykb44qcl40yg";
    fetchSubmodules = true;
  };
  shims = fetchFromGitHub {
    owner = "ghcjs";
    repo = "shims";
    rev = "01e01dee31a4786b3d01092e72350b0859a9f8c9"; # master branch
    sha256 = "01m1yhq6l71azx0zqbpzmqc6rxxf654hgjibc0lz2cg5942wh1hf";
  };
in mkDerivation (rec {
  pname = "ghcjs";
  inherit version;
  # `src` is ghcjs's a3157072c2593debf2e45e751e9a8aa90b860b4d plus this
  # additional dependency bump: https://github.com/ghcjs/ghcjs/pull/408
  src = fetchFromGitHub {
    owner = "k0001";
    repo = "ghcjs";
    rev = "1b767e0b3dabdd1561bd17314d472651bfd9b97c";
    sha256 = "0j4vj47qljbcbrp3md3jwxwl2kz9k85visq6yi1x8wdch4wb2kgy";
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
  postInstall = ''
    PATH=$out/bin:$PATH LD_LIBRARY_PATH=${gmp.out}/lib:${stdenv.cc}/lib64:$LD_LIBRARY_PATH \
      env -u GHC_PACKAGE_PATH $out/bin/ghcjs-boot \
        --dev \
        --with-cabal ${cabal-install}/bin/cabal \
        --with-gmp-includes ${gmp.dev}/include \
        --with-gmp-libraries ${gmp.out}/lib
  '';
  passthru = {
    isGhcjs = true;
    nativeGhc = ghc;
    inherit nodejs;
  };

  homepage = "https://github.com/ghcjs/ghcjs";
  description = "A Haskell to JavaScript compiler that uses the GHC API";
  license = stdenv.lib.licenses.bsd3;
  platforms = ghc.meta.platforms;
  maintainers = with stdenv.lib.maintainers; [ jwiegley cstrahan ];
})
