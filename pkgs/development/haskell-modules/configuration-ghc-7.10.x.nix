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

  Extra = appendPatch super.Extra (pkgs.fetchpatch {
    url = "https://github.com/seereason/sr-extra/commit/29787ad4c20c962924b823d02a7335da98143603.patch";
    sha256 = "193i1xmq6z0jalwmq0mhqk1khz6zz0i1hs6lgfd7ybd6qyaqnf5f";
  });

  language-glsl = appendPatch super.language-glsl (pkgs.fetchpatch {
    url = "https://patch-diff.githubusercontent.com/raw/noteed/language-glsl/pull/10.patch";
    sha256 = "1d8dmfqw9y7v7dlszb7l3wp0vj77j950z2r3r0ar9mcvyrmfm4in";
  });

  # haddock: No input file(s).
  nats = dontHaddock super.nats;
  bytestring-builder = dontHaddock super.bytestring-builder;

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
  pointfree = doJailbreak super.pointfree;

  # acid-state/safecopy#25 acid-state/safecopy#26
  safecopy = dontCheck (super.safecopy);

  # test suite broken, some instance is declared twice.
  # https://bitbucket.org/FlorianHartwig/attobencode/issue/1
  AttoBencode = dontCheck super.AttoBencode;

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

  # https://github.com/haskell/haddock/issues/378
  haddock-library_1_2_0 = dontCheck super.haddock-library_1_2_0;
  haddock-library = self.haddock-library_1_2_0;

  # Upstream was notified about the over-specified constraint on 'base'
  # but refused to do anything about it because he "doesn't want to
  # support a moving target". Go figure.
  barecheck = doJailbreak super.barecheck;

  syb-with-class = appendPatch super.syb-with-class (pkgs.fetchpatch {
    url = "https://github.com/seereason/syb-with-class/compare/adc86a9...719e567.patch";
    sha256 = "1lwwvxyhxcmppdapbgpfhwi7xc2z78qir03xjrpzab79p2qyq7br";
  });

  # https://github.com/kazu-yamamoto/unix-time/issues/30
  unix-time = dontCheck super.unix-time;

  # Until the changes have been pushed to Hackage
  mueval = appendPatch super.mueval (pkgs.fetchpatch {
    url = "https://github.com/gwern/mueval/commit/c41aa40ed63b74c069d1e4e3caa8c8d890cde960.patch";
    sha256 = "1gs8p89d1qsrd1qycbhf6kv4qw0sbb8m6dy106dqkmdzcjzcyq74";
  });
  present = appendPatch super.present (pkgs.fetchpatch {
    url = "https://github.com/chrisdone/present/commit/6a61f099bf01e2127d0c68f1abe438cd3eaa15f7.patch";
    sha256 = "1vn3xm38v2f4lzyzkadvq322f3s2yf8c88v56wpdpzfxmvlzaqr8";
  });

  # Already applied in darcs repository.
  gnuplot = appendPatch super.gnuplot ./gnuplot-fix-new-time.patch;

  ghcjs-prim = self.callPackage ({ mkDerivation, fetchgit, primitive }: mkDerivation {
    pname = "ghcjs-prim";
    version = "0.1.0.0";
    src = fetchgit {
      url = git://github.com/ghcjs/ghcjs-prim.git;
      rev = "dfeaab2aafdfefe46bf12960d069f28d2e5f1454"; # ghc-7.10 branch
      sha256 = "19kyb26nv1hdpp0kc2gaxkq5drw5ib4za0641py5i4bbf1g58yvy";
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

  misfortune = appendPatch super.misfortune (pkgs.fetchpatch {
    url = "https://github.com/mokus0/misfortune/commit/9e0a38cf8d59a0de9ae1156034653f32099610e4.patch";
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

  # FIXME: remove with the next Hackage update
  brainfuck = appendPatch super.brainfuck ./brainfuck-fix-ghc710.patch;
  unlambda = appendPatch super.unlambda ./unlambda-fix-ghc710.patch;

  # https://github.com/BNFC/bnfc/issues/137
  BNFC = markBrokenVersion "2.7.1" super.BNFC;
  cubical = dontDistribute super.cubical;

  # contacted maintainer by e-mail
  HList = markBrokenVersion "0.3.4.1" super.HList;
  AspectAG = dontDistribute super.AspectAG;
  Rlang-QQ = dontDistribute super.Rlang-QQ;
  SyntaxMacros = dontDistribute super.SyntaxMacros;
  expand = dontDistribute super.expand;
  functional-arrow = dontDistribute super.functional-arrow;
  guess-combinator = dontDistribute super.guess-combinator;
  ihaskell-rlangqq = dontDistribute super.ihaskell-rlangqq;
  ipopt-hs = dontDistribute super.ipopt-hs;
  murder = dontDistribute super.murder;
  netcore = dontDistribute super.netcore;
  nettle-frp = dontDistribute super.nettle-frp;
  nettle-netkit = dontDistribute super.nettle-netkit;
  nettle-openflow = dontDistribute super.nettle-openflow;
  oberon0 = dontDistribute super.oberon0;
  poly-arity = dontDistribute super.poly-arity;
  respond = dontDistribute super.respond;
  semi-iso = dontDistribute super.semi-iso;
  syntax = dontDistribute super.syntax;
  syntax-attoparsec = dontDistribute super.syntax-attoparsec;
  syntax-example = dontDistribute super.syntax-example;
  syntax-example-json = dontDistribute super.syntax-example-json;
  syntax-pretty = dontDistribute super.syntax-pretty;
  syntax-printer = dontDistribute super.syntax-printer;
  tuple-hlist = dontDistribute super.tuple-hlist;
  tuple-morph = dontDistribute super.tuple-morph;

  # contacted maintainer by e-mail
  cmdlib = markBroken super.cmdlib;
  darcs-fastconvert = dontDistribute super.darcs-fastconvert;
  ivory-backend-c = dontDistribute super.ivory-backend-c;
  ivory-bitdata = dontDistribute super.ivory-bitdata;
  ivory-examples = dontDistribute super.ivory-examples;
  ivory-hw = dontDistribute super.ivory-hw;
  laborantin-hs = dontDistribute super.laborantin-hs;

  # https://github.com/cartazio/arithmoi/issues/1
  arithmoi = markBroken super.arithmoi;
  NTRU = dontDistribute super.NTRU;
  arith-encode = dontDistribute super.arith-encode;
  barchart = dontDistribute super.barchart;
  constructible = dontDistribute super.constructible;
  cyclotomic = dontDistribute super.cyclotomic;
  diagrams = dontDistribute super.diagrams;
  diagrams-contrib = dontDistribute super.diagrams-contrib;
  enumeration = dontDistribute super.enumeration;
  ghci-diagrams = dontDistribute super.ghci-diagrams;
  ihaskell-diagrams = dontDistribute super.ihaskell-diagrams;
  nimber = dontDistribute super.nimber;
  pell = dontDistribute super.pell;
  quadratic-irrational = dontDistribute super.quadratic-irrational;

  # https://github.com/kazu-yamamoto/ghc-mod/issues/467
  ghc-mod = markBroken super.ghc-mod;
  HaRe = dontDistribute super.HaRe;
  ghc-imported-from = dontDistribute super.ghc-imported-from;
  git-vogue = dontDistribute super.git-vogue;
  haskell-token-utils = dontDistribute super.haskell-token-utils;
  hbb = dontDistribute super.hbb;
  hsdev = dontDistribute super.hsdev;

  # http://hub.darcs.net/ivanm/graphviz/issue/5
  graphviz = markBroken super.graphviz;
  Graphalyze = dontDistribute super.Graphalyze;
  HLearn-approximation = dontDistribute super.HLearn-approximation;
  HLearn-classification = dontDistribute super.HLearn-classification;
  HLearn-distributions = dontDistribute super.HLearn-distributions;
  SourceGraph = dontDistribute super.SourceGraph;
  Zora = dontDistribute super.Zora;
  ampersand = dontDistribute super.ampersand;
  caffegraph = dontDistribute super.caffegraph;
  dot2graphml = dontDistribute super.dot2graphml;
  dvda = dontDistribute super.dvda;
  erd = dontDistribute super.erd;
  filediff = dontDistribute super.filediff;
  fsmActions = dontDistribute super.fsmActions;
  gbu = dontDistribute super.gbu;
  geni-gui = dontDistribute super.geni-gui;
  ghc-vis = dontDistribute super.ghc-vis;
  grammar-combinators = dontDistribute super.grammar-combinators;
  llvm-analysis = dontDistribute super.llvm-analysis;
  llvm-base-types = dontDistribute super.llvm-base-types;
  llvm-data-interop = dontDistribute super.llvm-data-interop;
  llvm-tools = dontDistribute super.llvm-tools;
  marxup = dontDistribute super.marxup;
  mathgenealogy = dontDistribute super.mathgenealogy;
  optimusprime = dontDistribute super.optimusprime;
  phybin = dontDistribute super.phybin;
  prolog-graph = dontDistribute super.prolog-graph;
  prolog-graph-lib = dontDistribute super.prolog-graph-lib;
  teams = dontDistribute super.teams;
  vacuum-graphviz = dontDistribute super.vacuum-graphviz;
  vampire = dontDistribute super.vampire;
  visual-graphrewrite = dontDistribute super.visual-graphrewrite;
  xdot = dontDistribute super.xdot;

  # https://github.com/lymar/hastache/issues/47
  hastache = dontCheck super.hastache;

  # The compat library is empty in the presence of mtl 2.2.x.
  mtl-compat = dontHaddock super.mtl-compat;

  # https://github.com/bos/bloomfilter/issues/11
  bloomfilter = dontHaddock (appendConfigureFlag super.bloomfilter "--ghc-option=-XFlexibleContexts");

  # https://github.com/ocharles/tasty-rerun/issues/5
  tasty-rerun = dontHaddock (appendConfigureFlag super.tasty-rerun "--ghc-option=-XFlexibleContexts");

  # Broken with GHC 7.10.x.
  aeson_0_7_0_6 = markBroken super.aeson_0_7_0_6;
  annotated-wl-pprint_0_5_3 = markBroken super.annotated-wl-pprint_0_5_3;
  c2hs_0_20_1 = markBroken super.c2hs_0_20_1;
  Cabal_1_20_0_3 = markBroken super.Cabal_1_20_0_3;
  cabal-install_1_18_1_0 = markBroken super.cabal-install_1_18_1_0;
  containers_0_4_2_1 = markBroken super.containers_0_4_2_1;
  control-monad-free_0_5_3 = markBroken super.control-monad-free_0_5_3;
  equivalence_0_2_5 = markBroken super.equivalence_0_2_5;
  haddock-api_2_15_0_2 = markBroken super.haddock-api_2_15_0_2;
  lens_4_7_0_1 = markBroken super.lens_4_7_0_1;
  optparse-applicative_0_10_0 = markBroken super.optparse-applicative_0_10_0;
  QuickCheck_1_2_0_1 = markBroken super.QuickCheck_1_2_0_1;
  seqid-streams_0_1_0 = markBroken super.seqid-streams_0_1_0;
  vector_0_10_9_3 = markBroken super.vector_0_10_9_3;

  # https://github.com/purefn/hipbot/issues/1
  hipbot = dontDistribute super.hipbot;

  # https://github.com/HugoDaniel/RFC3339/issues/14
  timerep = dontCheck super.timerep;

}
