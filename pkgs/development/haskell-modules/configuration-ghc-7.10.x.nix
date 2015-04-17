{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Suitable LLVM version.
  llvmPackages = pkgs.llvmPackages_35;

  # Disable GHC 7.10.x core libraries.
  array = null;
  base = null;
  binary = null;
  bin-package-db = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
  ghc-prim = null;
  haskeline = null;
  hoopl = null;
  hpc = null;
  integer-gmp = null;
  pretty = null;
  process = null;
  rts = null;
  template-haskell = null;
  terminfo = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # should be fixed in versions > 0.6
  pandoc-citeproc = overrideCabal super.pandoc-citeproc (drv: {
    patches = [
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc-citeproc/commit/4e4f9c2.patch";
         sha256 = "18b08k56g5q4zz6jxczkrddblyn52vmd0811n1icfdpzqhgykn4p";
      })
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc-citeproc/commit/34cc147.patch";
         sha256 = "09vrdvg5w14qckn154zlxvk6i2ikmmhpsl9mxycxkql3rl4dqam3";
      })
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc-citeproc/commit/8242c70.patch";
         sha256 = "1lqpwxzz2www81w4mym75z36bsavqfj67hyvzn20ffvxq42yw7ry";
      })
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc-citeproc/commit/e59f88d.patch";
         sha256 = "05699hj3qa2vrfdnikj7rzmc2ajrkd7p8yd4cjlhmqq9asq90xzb";
      })
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc-citeproc/commit/ae6ca86.patch";
         sha256 = "19cag39k5s7iqagpvss9c2ny5g0lwnrawaqcc0labihc1a181k8l";
      })
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc-citeproc/commit/f5a9fc7.patch";
         sha256 = "08lsinh3mkjpz3cqj5i1vcnzkyl07jp38qcjcwcw7m2b7gsjbpvm";
      })
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc-citeproc/commit/780a554.patch";
         sha256 = "1kfn0mcp3vp32c9w8gyz0p0jv0xn90as9mxm8a2lmjng52jlzvy4";
      })
   ];
  });

  # ekmett/linear#74
  linear = overrideCabal super.linear (drv: {
    prePatch = "sed -i 's/-Werror//g' linear.cabal";
  });

  # Cabal_1_22_1_1 requires filepath >=1 && <1.4
  cabal-install = dontCheck (super.cabal-install.override { Cabal = null; });

  HStringTemplate = self.HStringTemplate_0_8_3;

  # We have Cabal 1.22.x.
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = null; };

  # GHC 7.10.x's Haddock binary cannot generate hoogle files.
  # https://ghc.haskell.org/trac/ghc/ticket/9921
  mkDerivation = drv: super.mkDerivation (drv // { doHoogle = false; });

  # haddock: No input file(s).
  nats = dontHaddock super.nats;
  bytestring-builder = dontHaddock super.bytestring-builder;

  # We have transformers 4.x
  mtl = self.mtl_2_2_1;
  transformers-compat = disableCabalFlag super.transformers-compat "three";

  # We have time 1.5
  aeson = disableCabalFlag super.aeson "old-locale";

  # requires filepath >=1.1 && <1.4
  Glob = doJailbreak super.Glob;

  # Setup: At least the following dependencies are missing: base <4.8
  hspec-expectations = overrideCabal super.hspec-expectations (drv: {
    patchPhase = "sed -i -e 's|base < 4.8|base|' hspec-expectations.cabal";
  });
  utf8-string = overrideCabal super.utf8-string (drv: {
    patchPhase = "sed -i -e 's|base >= 3 && < 4.8|base|' utf8-string.cabal";
  });
  esqueleto = doJailbreak super.esqueleto;
  pointfree = doJailbreak super.pointfree;

  # acid-state/safecopy#25 acid-state/safecopy#26
  safecopy = dontCheck (super.safecopy);

  # bos/attoparsec#92
  attoparsec = dontCheck super.attoparsec;

  # Test suite fails with some (seemingly harmless) error.
  # https://code.google.com/p/scrapyourboilerplate/issues/detail?id=24
  syb = dontCheck super.syb;

  # Test suite has stricter version bounds
  retry = dontCheck super.retry;

  # Test suite fails with time >= 1.5
  http-date = dontCheck super.http-date;

  # Version 1.19.5 fails its test suite.
  happy = dontCheck super.happy;

  # Test suite fails in "/tokens_bytestring_unicode.g.bin".
  alex = dontCheck super.alex;

  # TODO: should eventually update the versions in hackage-packages.nix
  haddock-library = overrideCabal super.haddock-library (drv: {
    version = "1.2.0";
    sha256 = "0kf8qihkxv86phaznb3liq6qhjs53g3iq0zkvz5wkvliqas4ha56";
  });
  haddock-api = overrideCabal super.haddock-api (drv: {
    version = "2.16.0";
    sha256 = "0hk42w6fbr6xp8xcpjv00bhi9r75iig5kp34vxbxdd7k5fqxr1hj";
  });
  haddock = overrideCabal super.haddock (drv: {
    version = "2.16.0";
    sha256 = "1afb96w1vv3gmvha2f1h3p8zywpdk8dfk6bgnsa307ydzsmsc3qa";
  });

  # Upstream was notified about the over-specified constraint on 'base'
  # but refused to do anything about it because he "doesn't want to
  # support a moving target". Go figure.
  barecheck = doJailbreak super.barecheck;

  syb-with-class = appendPatch super.syb-with-class (pkgs.fetchpatch {
    url = "https://github.com/seereason/syb-with-class/compare/adc86a9...719e567.patch";
    sha256 = "1lwwvxyhxcmppdapbgpfhwi7xc2z78qir03xjrpzab79p2qyq7br";
  });

  wl-pprint = overrideCabal super.wl-pprint (drv: {
    postPatch = "sed -i '113iimport Prelude hiding ((<$>))' Text/PrettyPrint/Leijen.hs";
    jailbreak = true;
  });

  # https://github.com/kazu-yamamoto/unix-time/issues/30
  unix-time = dontCheck super.unix-time;

  # Until the changes have been pushed to Hackage
  annotated-wl-pprint = appendPatch super.annotated-wl-pprint (pkgs.fetchpatch {
    url = "https://patch-diff.githubusercontent.com/raw/david-christiansen/annotated-wl-pprint/pull/2.patch";
    sha256 = "0n0fbq3vd7b9kfmhg089q0dy40vawq4q88il3zc9ybivhi62nwv4";
  });
  ghc-events = appendPatch super.ghc-events (pkgs.fetchpatch {
    url = "https://patch-diff.githubusercontent.com/raw/haskell/ghc-events/pull/8.patch";
    sha256 = "1k881jrvzfvs761jgfhf5nsbmbc33c9333l4s0f5088p46ff2n1l";
  });
  dependent-sum-template = appendPatch super.dependent-sum-template (pkgs.fetchpatch {
    url = "https://patch-diff.githubusercontent.com/raw/mokus0/dependent-sum-template/pull/4.patch";
    sha256 = "1yb1ny4ckl4d3sf4xnvpbsa9rw2dficzgipijs5s3729dnsc3rb0";
  });
  mueval = appendPatch super.mueval (pkgs.fetchpatch {
    url = "https://patch-diff.githubusercontent.com/raw/gwern/mueval/pull/10.patch";
    sha256 = "1gs8p89d1qsrd1qycbhf6kv4qw0sbb8m6dy106dqkmdzcjzcyq74";
  });

  # Already applied in darcs repository.
  gnuplot = appendPatch super.gnuplot ./gnuplot-fix-new-time.patch;

  ghcjs-prim = self.callPackage ({ mkDerivation, fetchgit, primitive }: mkDerivation {
    pname = "ghcjs-prim";
    version = "0.1.0.0";
    src = fetchgit {
      url = git://github.com/ghcjs/ghcjs-prim.git;
      rev = "ca08e46257dc276e01d08fb47a693024bae001fa"; # ghc-7.10 branch
      sha256 = "0w7sqzp5p70yhmdhqasgkqbf3b61wb24djlavwil2j8ry9y472w3";
    };
    buildDepends = [ primitive ];
    license = pkgs.stdenv.lib.licenses.bsd3;
  }) {};

  # diagrams/monoid-extras#19
  monoid-extras = overrideCabal super.monoid-extras (drv: {
    prePatch = "sed -i 's|4\.8|4.9|' monoid-extras.cabal";
  });

  # diagrams/statestack#5
  statestack = overrideCabal super.statestack (drv: {
    prePatch = "sed -i 's|4\.8|4.9|' statestack.cabal";
  });

  # diagrams/diagrams-core#83
  diagrams-core = overrideCabal super.diagrams-core (drv: {
    prePatch = "sed -i 's|4\.8|4.9|' diagrams-core.cabal";
  });

  # diagrams/diagrams-core#83
  diagrams-lib = overrideCabal super.diagrams-lib (drv: {
    prePatch = "sed -i 's|4\.8|4.9|' diagrams-lib.cabal";
    patches = [ ./diagrams-lib-flexible-contexts.patch ];
  });

  # https://github.com/mokus0/misfortune/pull/1
  misfortune = appendPatch super.misfortune (pkgs.fetchpatch {
    url = "https://patch-diff.githubusercontent.com/raw/mokus0/misfortune/pull/1.patch";
    sha256 = "15frwdallm3i6k7mil26bbjd4wl6k9h20ixf3cmyris3q3jhlcfh";
  });

  timezone-series = doJailbreak super.timezone-series;
  timezone-olson = doJailbreak super.timezone-olson;
  libmpd = dontCheck super.libmpd;
  xmonad-extras = overrideCabal super.xmonad-extras (drv: {
    postPatch = ''
      sed -i -e "s,<\*,<¤,g" XMonad/Actions/Volume.hs
    '';
  });

  # Workaround for a workaround, see comment for "ghcjs" flag.
  jsaddle = let jsaddle' = disableCabalFlag super.jsaddle "ghcjs";
            in addBuildDepends jsaddle' [ self.glib self.gtk3 self.webkitgtk3
                                          self.webkitgtk3-javascriptcore ];

  # Fix evaluation in GHC >=7.8: https://github.com/lambdabot/lambdabot/issues/116
  lambdabot = appendPatch super.lambdabot ./lambdabot-fix-ghc78.patch;

  # These packages don't have maintainers.
  brainfuck = appendPatch super.brainfuck ./brainfuck-fix-ghc710.patch;
  unlambda = appendPatch super.unlambda ./unlambda-fix-ghc710.patch;

  # Sent e-mail to the maintainer.
  IOSpec = appendPatch super.IOSpec ./IOSpec-fix-ghc710.patch;

  # Updated Cabal file from Hackage tightened version bounds for some reason.
  edit-distance = let pkg = appendPatch super.edit-distance ./edit-distance-fix-boundaries.patch;
                  in appendPatch pkg (pkgs.fetchpatch {
                    url = "https://patch-diff.githubusercontent.com/raw/batterseapower/edit-distance/pull/3.patch";
                    sha256 = "013x9za47vr9jx0liwgi8cdh2h2882a87h5nqvr41xqipzxfiyw1";
                  });

  # https://github.com/BNFC/bnfc/issues/137
  BNFC = markBrokenVersion "2.7.1" super.BNFC;
  cubical = dontDistribute super.cubical;

  # contacted maintainer by e-mail
  HList = markBrokenVersion "0.3.4.1" super.HList;
  ihaskell-rlangqq = dontDistribute super.ihaskell-rlangqq;
  Rlang-QQ = dontDistribute super.Rlang-QQ;
  semi-iso = dontDistribute super.semi-iso;
  syntax = dontDistribute super.syntax;
  syntax-attoparsec = dontDistribute super.syntax-attoparsec;
  syntax-example = dontDistribute super.syntax-example;
  syntax-example-json = dontDistribute super.syntax-example-json;
  syntax-printer = dontDistribute super.syntax-printer;
  tuple-hlist = dontDistribute super.tuple-hlist;
  tuple-morph = dontDistribute super.tuple-morph;

  # contacted maintainer by e-mail
  cmdlib = markBroken super.cmdlib;
  laborantin-hs = dontDistribute super.laborantin-hs;

  # https://github.com/koalaman/shellcheck/issues/352
  ShellCheck = markBroken super.ShellCheck;

  # https://github.com/cartazio/arithmoi/issues/1
  arithmoi = markBroken super.arithmoi;
  constructible = dontDistribute super.constructible;
  cyclotomic = dontDistribute super.cyclotomic;
  diagrams = dontDistribute super.diagrams;
  diagrams-contrib = dontDistribute super.diagrams-contrib;
  ihaskell-diagrams = dontDistribute super.ihaskell-diagrams;
  nimber = dontDistribute super.nimber;
  NTRU = dontDistribute super.NTRU;
  quadratic-irrational = dontDistribute super.quadratic-irrational;

  # https://github.com/kazu-yamamoto/ghc-mod/issues/467
  ghc-mod = markBroken super.ghc-mod;
  ghc-imported-from = dontDistribute super.ghc-imported-from;
  git-vogue = dontDistribute super.git-vogue;
  hsdev = dontDistribute super.hsdev;

  # http://hub.darcs.net/ivanm/graphviz/issue/5
  graphviz = markBroken super.graphviz;
  Graphalyze = dontDistribute super.Graphalyze;
  Zora = dontDistribute super.Zora;
  ampersand = dontDistribute super.ampersand;
  caffegraph = dontDistribute super.caffegraph;
  dot2graphml = dontDistribute super.dot2graphml;
  erd = dontDistribute super.erd;
  filediff = dontDistribute super.filediff;
  fsmActions = dontDistribute super.fsmActions;
  ghc-vis = dontDistribute super.ghc-vis;
  llvm-base-types = dontDistribute super.llvm-base-types;
  mathgenealogy = dontDistribute super.mathgenealogy;
  vacuum-graphviz = dontDistribute super.vacuum-graphviz;
  xdot = dontDistribute super.xdot;

  # https://github.com/lymar/hastache/issues/47
  hastache = dontCheck super.hastache;

}
