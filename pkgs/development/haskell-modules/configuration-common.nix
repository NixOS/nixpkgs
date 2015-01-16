{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Some packages need a non-core version of Cabal.
  Cabal_1_18_1_6 = dontCheck super.Cabal_1_18_1_6;
  Cabal_1_20_0_3 = dontCheck super.Cabal_1_20_0_3;
  Cabal_1_22_0_0 = dontCheck super.Cabal_1_22_0_0;
  cabal-install = dontCheck (super.cabal-install.override { Cabal = self.Cabal_1_22_0_0; });

  # Break infinite recursions.
  digest = super.digest.override { inherit (pkgs) zlib; };
  Dust-crypto = dontCheck super.Dust-crypto;
  hasql-postgres = dontCheck super.hasql-postgres;
  hspec-expectations = dontCheck super.hspec-expectations;
  HTTP = dontCheck super.HTTP;
  matlab = super.matlab.override { matlab = null; };
  mwc-random = dontCheck super.mwc-random;
  nanospec = dontCheck super.nanospec;
  options = dontCheck super.options;
  statistics = dontCheck super.statistics;
  text = dontCheck super.text;

  # Doesn't compile with lua 5.2.
  hslua = super.hslua.override { lua = pkgs.lua5_1; };

  # Please also remove optparse-applicative special case from
  # cabal2nix/hackage2nix.hs when removing the following.
  elm-make = super.elm-make.override { optparse-applicative = self.optparse-applicative_0_10_0; };
  elm-package = super.elm-package.override { optparse-applicative = self.optparse-applicative_0_10_0; };

  # https://github.com/acid-state/safecopy/issues/17
  safecopy = dontCheck super.safecopy;

  # Link the proper version.
  zeromq4-haskell = super.zeromq4-haskell.override { zeromq = pkgs.zeromq4; };

  # "curl" means pkgs.curl
  git-annex = super.git-annex.override { inherit (pkgs) git rsync gnupg1 curl lsof openssh which bup perl wget; };

  # Depends on code distributed under a non-free license.
  bindings-yices = dontDistribute super.bindings-yices;
  yices = dontDistribute super.yices;
  yices-easy = dontDistribute super.yices-easy;
  yices-painless = dontDistribute super.yices-painless;

  # This package overrides the one from pkgs.gnome.
  gtkglext = super.gtkglext.override { inherit (pkgs.gnome) gtkglext; };

  # The test suite refers to its own library with an invalid version constraint.
  presburger = dontCheck super.presburger;

  # Won't find it's header files without help.
  sfml-audio = appendConfigureFlag super.sfml-audio "--extra-include-dirs=${pkgs.openal}/include/AL";

  # https://github.com/haskell/time/issues/23
  time_1_5_0_1 = dontCheck super.time_1_5_0_1;

  # Doesn't accept modern versions of hashtable.
  Agda = dontHaddock super.Agda;

  # Cannot compile its own test suite: https://github.com/haskell/network-uri/issues/10.
  network-uri = dontCheck super.network-uri;

  # The Haddock phase fails for one reason or another.
  attoparsec-conduit = dontHaddock super.attoparsec-conduit;
  blaze-builder-conduit = dontHaddock super.blaze-builder-conduit;
  bytestring-progress = dontHaddock super.bytestring-progress;
  comonads-fd = dontHaddock super.comonads-fd;
  comonad-transformers = dontHaddock super.comonad-transformers;
  diagrams = dontHaddock super.diagrams;
  either = dontHaddock super.either;
  gl = dontHaddock super.gl;
  groupoids = dontHaddock super.groupoids;
  hamlet = dontHaddock super.hamlet;
  haste-compiler = dontHaddock super.haste-compiler;
  HaXml = dontHaddock super.HaXml;
  HDBC-odbc = dontHaddock super.HDBC-odbc;
  hoodle-core = dontHaddock super.hoodle-core;
  hsc3-db = dontHaddock super.hsc3-db;
  hspec-discover = dontHaddock super.hspec-discover;
  http-client-conduit = dontHaddock super.http-client-conduit;
  http-client-multipart = dontHaddock super.http-client-multipart;
  markdown-unlit = dontHaddock super.markdown-unlit;
  network-conduit = dontHaddock super.network-conduit;
  shakespeare-text = dontHaddock super.shakespeare-text;

  # jailbreak doesn't get the job done because the Cabal file uses conditionals a lot.
  darcs = overrideCabal super.darcs (drv: {
    patchPhase = "sed -i -e 's|random.*==.*|random|' -e 's|text.*>=.*,|text,|' -e s'|terminfo == .*|terminfo|' darcs.cabal";
  });

  # The test suite imposes too narrow restrictions on the version of
  # Cabal that can be used to build this package.
  cabal-test-quickcheck = dontCheck super.cabal-test-quickcheck;

  # https://github.com/techtangents/ablist/issues/1
  ABList = dontCheck super.ABList;

  # Depends on broken NewBinary package.
  ASN1 = markBroken super.ASN1;

  # Depends on broken Hails package.
  hails-bin = markBroken super.hails-bin;

  # Depends on broken frame package.
  frame-markdown = markBroken super.frame-markdown;

  # Depends on broken lss package.
  snaplet-lss = markBroken super.snaplet-lss;

  # depends on broken hbro package.
  hbro-contrib = markBroken super.hbro-contrib;

  # https://github.com/haskell/vector/issues/47
  vector = if pkgs.stdenv.isi686 then appendConfigureFlag super.vector "--ghc-options=-msse2" else super.vector;

}
// {
  # Not on Hackage yet.
  cabal2nix = self.mkDerivation {
    pname = "cabal2nix";
    version = "2.0";
    src = pkgs.fetchgit {
      url = "git://github.com/NixOS/cabal2nix.git";
      rev = "2a1a10f38f21f27e6555b399db131380af1cf7ff";
      sha256 = "51c96e5a089396c34bfa27e76778743161504e04d6220b2bb7e0fbcde80430fa";
    };
    isLibrary = false;
    isExecutable = true;
    buildDepends = with self; [
      aeson base bytestring Cabal containers deepseq deepseq-generics
      directory filepath hackage-db hspec monad-par monad-par-extras
      mtl pretty process regex-posix SHA split transformers
      utf8-string QuickCheck
    ];
    testDepends = with self; [ base doctest ];
    homepage = "http://github.com/NixOS/cabal2nix";
    description = "Convert Cabal files into Nix build instructions";
    license = pkgs.stdenv.lib.licenses.bsd3;
  };
}
