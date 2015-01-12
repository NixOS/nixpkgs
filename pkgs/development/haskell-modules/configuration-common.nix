{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Some packages need a non-core version of Cabal.
  Cabal_1_18_1_6 = doJailbreak (dontCheck super.Cabal_1_18_1_6);
  Cabal_1_20_0_3 = doJailbreak (dontCheck super.Cabal_1_20_0_3);
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

  # Won't accept recent random: https://bitbucket.org/dafis/arithmoi/issue/14/outdated-dependency-on-random.
  arithmoi = doJailbreak super.arithmoi;

  # Doesn't accept modern versions of hashtable.
  Agda = dontHaddock (doJailbreak super.Agda);

  # Cannot compile its own test suite: https://github.com/haskell/network-uri/issues/10.
  network-uri = dontCheck super.network-uri;

  # 0.7.0.2 doesn't accept recent versions of HaXml.
  encoding = doJailbreak super.encoding;

  # Doesn't accept recent versions of vector-space.
  active = doJailbreak super.active;
  diagrams-core = doJailbreak super.diagrams-core; # https://github.com/diagrams/diagrams-core/issues/78
  diagrams-contrib = doJailbreak super.diagrams-contrib;
  diagrams-lib = doJailbreak super.diagrams-lib;
  diagrams-svg = doJailbreak super.diagrams-svg;
  force-layout = doJailbreak super.force-layout;
  vector-space-points = doJailbreak super.vector-space-points;

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

  # https://github.com/gcross/AbortT-transformers/issues/1
  AbortT-transformers = doJailbreak super.AbortT-transformers;

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

}
// {
  # Not on Hackage yet.
  cabal2nix = self.mkDerivation {
    pname = "cabal2nix";
    version = "2.0";
    src = pkgs.fetchgit {
      url = "git://github.com/NixOS/cabal2nix.git";
      sha256 = "b9dde970f8e64fd5faff9402f5788ee832874d7584a67210f59f2c5e504ce631";
      rev = "6398667f4ad670eb3aa3334044a65a06971494d0";
    };
    isLibrary = false;
    isExecutable = true;
    buildDepends = with self; [
      aeson base bytestring Cabal containers deepseq directory filepath
      hackage-db monad-par monad-par-extras mtl pretty process
      regex-posix SHA split transformers utf8-string
    ];
    testDepends = with self; [ base doctest ];
    homepage = "http://github.com/NixOS/cabal2nix";
    description = "Convert Cabal files into Nix build instructions";
    license = pkgs.stdenv.lib.licenses.bsd3;
  };
}
