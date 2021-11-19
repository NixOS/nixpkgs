{ pkgs, haskellLib }:
let
  # head-hackage-version = "2021-11-10";
  head-hackage-src = pkgs.fetchgit {
    url = "https://gitlab.haskell.org/ghc/head.hackage/";
    rev = "c50d7587a23ef1260721e84f8bcc1450d73177db";
    sha256 = "03q7a83is709q8hs5r62avhp0l1dk9k5agalmyragbrcj8s2q2fs";
  };
  dontRevise = haskellLib.overrideCabal (old: { editedCabalFile = null; });
  setCabalFile = file:
    haskellLib.overrideCabal
    (old: { postPatch = "cp ${file} ${old.pname}.cabal"; });
in self: super: {

  Agda = if super.Agda == null then
    super.Agda
  else if super.Agda.version == "2.6.1.3" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/Agda-2.6.1.3.patch"
        super.Agda)))
  else
    super.Agda;

  Cabal = if super.Cabal == null then
    super.Cabal
  else if super.Cabal.version == "2.4.1.0" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/Cabal-2.4.1.0.patch"
        super.Cabal)))
  else if super.Cabal.version == "3.0.2.0" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/Cabal-3.0.2.0.patch"
        super.Cabal)))
  else if super.Cabal.version == "3.2.1.0" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/Cabal-3.2.1.0.patch"
        super.Cabal)))
  else
    super.Cabal;

  Diff = if super.Diff == null then
    super.Diff
  else if super.Diff.version == "0.4.0" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/Diff-0.4.0.patch"
        super.Diff)))
  else
    super.Diff;

  EdisonAPI = if super.EdisonAPI == null then
    super.EdisonAPI
  else if super.EdisonAPI.version == "1.3.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/EdisonAPI-1.3.1.patch" super.EdisonAPI)))
  else
    super.EdisonAPI;

  EdisonCore = if super.EdisonCore == null then
    super.EdisonCore
  else if super.EdisonCore.version == "1.3.2.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/EdisonCore-1.3.2.1.patch" super.EdisonCore)))
  else
    super.EdisonCore;

  FPretty = if super.FPretty == null then
    super.FPretty
  else if super.FPretty.version == "1.1" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/FPretty-1.1.patch"
        super.FPretty)))
  else
    super.FPretty;

  HTTP = if super.HTTP == null then
    super.HTTP
  else if super.HTTP.version == "4000.3.16" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/HTTP-4000.3.16.patch"
        super.HTTP)))
  else
    super.HTTP;

  HUnit = if super.HUnit == null then
    super.HUnit
  else if super.HUnit.version == "1.6.2.0" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/HUnit-1.6.2.0.patch"
        super.HUnit)))
  else
    super.HUnit;

  QuickCheck = if super.QuickCheck == null then
    super.QuickCheck
  else if super.QuickCheck.version == "2.14.2" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/QuickCheck-2.14.2.patch" super.QuickCheck)))
  else
    super.QuickCheck;

  Spock-core = if super.Spock-core == null then
    super.Spock-core
  else if super.Spock-core.version == "0.14.0.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/Spock-core-0.14.0.0.patch"
      super.Spock-core)))
  else
    super.Spock-core;

  aeson = if super.aeson == null then
    super.aeson
  else if super.aeson.version == "1.5.6.0" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/aeson-1.5.6.0.patch"
        super.aeson)))
  else
    super.aeson;

  aivika = if super.aivika == null then
    super.aivika
  else if super.aivika.version == "5.9.1" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/aivika-5.9.1.patch"
        super.aivika)))
  else
    super.aivika;

  aivika-transformers = if super.aivika-transformers == null then
    super.aivika-transformers
  else if super.aivika-transformers.version == "5.9.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/aivika-transformers-5.9.1.patch"
      super.aivika-transformers)))
  else
    super.aivika-transformers;

  alex = if super.alex == null then
    super.alex
  else if super.alex.version == "3.2.6" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/alex-3.2.6.patch"
        super.alex)))
  else
    super.alex;

  ansi-pretty = if super.ansi-pretty == null then
    super.ansi-pretty
  else if super.ansi-pretty.version == "0.1.2.2" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/ansi-pretty-0.1.2.2.patch"
      super.ansi-pretty)))
  else
    super.ansi-pretty;

  arith-encode = if super.arith-encode == null then
    super.arith-encode
  else if super.arith-encode.version == "1.0.2" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/arith-encode-1.0.2.patch"
      super.arith-encode)))
  else
    super.arith-encode;

  async-pool = if super.async-pool == null then
    super.async-pool
  else if super.async-pool.version == "0.9.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/async-pool-0.9.1.patch" super.async-pool)))
  else
    super.async-pool;

  base-compat = if super.base-compat == null then
    super.base-compat
  else if super.base-compat.version == "0.11.2" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/base-compat-0.11.2.patch"
      super.base-compat)))
  else
    super.base-compat;

  base-compat-batteries = if super.base-compat-batteries == null then
    super.base-compat-batteries
  else if super.base-compat-batteries.version == "0.11.2" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/base-compat-batteries-0.11.2.patch"
      super.base-compat-batteries)))
  else
    super.base-compat-batteries;

  basement = if super.basement == null then
    super.basement
  else if super.basement.version == "0.0.12" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/basement-0.0.12.patch" super.basement)))
  else
    super.basement;

  boomerang = if super.boomerang == null then
    super.boomerang
  else if super.boomerang.version == "1.4.7" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/boomerang-1.4.7.patch" super.boomerang)))
  else
    super.boomerang;

  box-tuples = if super.box-tuples == null then
    super.box-tuples
  else if super.box-tuples.version == "0.2.0.4" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/box-tuples-0.2.0.4.patch" super.box-tuples)))
  else
    super.box-tuples;

  byteslice = if super.byteslice == null then
    super.byteslice
  else if super.byteslice.version == "0.2.6.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/byteslice-0.2.6.0.patch" super.byteslice)))
  else
    super.byteslice;

  bytesmith = if super.bytesmith == null then
    super.bytesmith
  else if super.bytesmith.version == "0.3.8.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/bytesmith-0.3.8.0.patch" super.bytesmith)))
  else
    super.bytesmith;

  bytestring-strict-builder = if super.bytestring-strict-builder == null then
    super.bytestring-strict-builder
  else if super.bytestring-strict-builder.version == "0.4.5.4" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/bytestring-strict-builder-0.4.5.4.patch"
      super.bytestring-strict-builder)))
  else
    super.bytestring-strict-builder;

  cabal-doctest = if super.cabal-doctest == null then
    super.cabal-doctest
  else if super.cabal-doctest.version == "1.0.9" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/cabal-doctest-1.0.9.patch"
      super.cabal-doctest)))
  else
    super.cabal-doctest;

  cantor-pairing = if super.cantor-pairing == null then
    super.cantor-pairing
  else if super.cantor-pairing.version == "0.2.0.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/cantor-pairing-0.2.0.1.patch"
      super.cantor-pairing)))
  else
    super.cantor-pairing;

  cassava = if super.cassava == null then
    super.cassava
  else if super.cassava.version == "0.5.2.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/cassava-0.5.2.0.patch" super.cassava)))
  else
    super.cassava;

  cborg = if super.cborg == null then
    super.cborg
  else if super.cborg.version == "0.2.6.0" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/cborg-0.2.6.0.patch"
        super.cborg)))
  else
    super.cborg;

  cereal = if super.cereal == null then
    super.cereal
  else if super.cereal.version == "0.5.8.2" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/cereal-0.5.8.2.patch"
        super.cereal)))
  else
    super.cereal;

  chaselev-deque = if super.chaselev-deque == null then
    super.chaselev-deque
  else if super.chaselev-deque.version == "0.5.0.5" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/chaselev-deque-0.5.0.5.patch"
      super.chaselev-deque)))
  else
    super.chaselev-deque;

  classy-prelude = if super.classy-prelude == null then
    super.classy-prelude
  else if super.classy-prelude.version == "1.5.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/classy-prelude-1.5.0.patch"
      super.classy-prelude)))
  else
    super.classy-prelude;

  combinat = if super.combinat == null then
    super.combinat
  else if super.combinat.version == "0.2.10.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/combinat-0.2.10.0.patch" super.combinat)))
  else
    super.combinat;

  commonmark-extensions = if super.commonmark-extensions == null then
    super.commonmark-extensions
  else if super.commonmark-extensions.version == "0.2.2.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/commonmark-extensions-0.2.2.1.patch"
      super.commonmark-extensions)))
  else
    super.commonmark-extensions;

  constraints = if super.constraints == null then
    super.constraints
  else if super.constraints.version == "0.13.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/constraints-0.13.1.patch"
      super.constraints)))
  else
    super.constraints;

  constraints-extras = if super.constraints-extras == null then
    super.constraints-extras
  else if super.constraints-extras.version == "0.3.2.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/constraints-extras-0.3.2.0.patch"
      super.constraints-extras)))
  else
    super.constraints-extras;

  contiguous = if super.contiguous == null then
    super.contiguous
  else if super.contiguous.version == "0.6.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/contiguous-0.6.1.patch" super.contiguous)))
  else
    super.contiguous;

  cql = if super.cql == null then
    super.cql
  else if super.cql.version == "4.0.3" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/cql-4.0.3.patch"
        super.cql)))
  else
    super.cql;

  critbit = if super.critbit == null then
    super.critbit
  else if super.critbit.version == "0.2.0.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/critbit-0.2.0.0.patch" super.critbit)))
  else
    super.critbit;

  cryptonite = if super.cryptonite == null then
    super.cryptonite
  else if super.cryptonite.version == "0.29" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/cryptonite-0.29.patch" super.cryptonite)))
  else
    super.cryptonite;

  data-bword = if super.data-bword == null then
    super.data-bword
  else if super.data-bword.version == "0.1.0.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/data-bword-0.1.0.1.patch" super.data-bword)))
  else
    super.data-bword;

  data-default-instances-new-base =
    if super.data-default-instances-new-base == null then
      super.data-default-instances-new-base
    else if super.data-default-instances-new-base.version == "0.0.2" then
      (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
        "${head-hackage-src}/patches/data-default-instances-new-base-0.0.2.patch"
        super.data-default-instances-new-base)))
    else
      super.data-default-instances-new-base;

  data-dword = if super.data-dword == null then
    super.data-dword
  else if super.data-dword.version == "0.3.2" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/data-dword-0.3.2.patch" super.data-dword)))
  else
    super.data-dword;

  data-r-tree = if super.data-r-tree == null then
    super.data-r-tree
  else if super.data-r-tree.version == "0.6.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/data-r-tree-0.6.0.patch" super.data-r-tree)))
  else
    super.data-r-tree;

  datetime = if super.datetime == null then
    super.datetime
  else if super.datetime.version == "0.3.1" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/datetime-0.3.1.patch"
        super.datetime)))
  else
    super.datetime;

  deferred-folds = if super.deferred-folds == null then
    super.deferred-folds
  else if super.deferred-folds.version == "0.9.17" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/deferred-folds-0.9.17.patch"
      super.deferred-folds)))
  else
    super.deferred-folds;

  dependent-sum-template = if super.dependent-sum-template == null then
    super.dependent-sum-template
  else if super.dependent-sum-template.version == "0.1.0.3" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/dependent-sum-template-0.1.0.3.patch"
      super.dependent-sum-template)))
  else
    super.dependent-sum-template;

  diagrams-lib = if super.diagrams-lib == null then
    super.diagrams-lib
  else if super.diagrams-lib.version == "1.4.4" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/diagrams-lib-1.4.4.patch"
      super.diagrams-lib)))
  else
    super.diagrams-lib;

  dom-lt = if super.dom-lt == null then
    super.dom-lt
  else if super.dom-lt.version == "0.2.2.1" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/dom-lt-0.2.2.1.patch"
        super.dom-lt)))
  else
    super.dom-lt;

  drinkery = if super.drinkery == null then
    super.drinkery
  else if super.drinkery.version == "0.4" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/drinkery-0.4.patch"
        super.drinkery)))
  else
    super.drinkery;

  edit-distance = if super.edit-distance == null then
    super.edit-distance
  else if super.edit-distance.version == "0.2.2.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/edit-distance-0.2.2.1.patch"
      super.edit-distance)))
  else
    super.edit-distance;

  emacs-module = if super.emacs-module == null then
    super.emacs-module
  else if super.emacs-module.version == "0.1.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/emacs-module-0.1.1.patch"
      super.emacs-module)))
  else
    super.emacs-module;

  endo = if super.endo == null then
    super.endo
  else if super.endo.version == "0.3.0.1" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/endo-0.3.0.1.patch"
        super.endo)))
  else
    super.endo;

  enumeration = if super.enumeration == null then
    super.enumeration
  else if super.enumeration.version == "0.2.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/enumeration-0.2.0.patch" super.enumeration)))
  else
    super.enumeration;

  extra = if super.extra == null then
    super.extra
  else if super.extra.version == "1.7.10" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/extra-1.7.10.patch"
        super.extra)))
  else
    super.extra;

  fgl = if super.fgl == null then
    super.fgl
  else if super.fgl.version == "5.7.0.3" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/fgl-5.7.0.3.patch"
        super.fgl)))
  else
    super.fgl;

  filepattern = if super.filepattern == null then
    super.filepattern
  else if super.filepattern.version == "0.1.2" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/filepattern-0.1.2.patch" super.filepattern)))
  else
    super.filepattern;

  focus = if super.focus == null then
    super.focus
  else if super.focus.version == "1.0.3" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/focus-1.0.3.patch"
        super.focus)))
  else
    super.focus;

  free-algebras = if super.free-algebras == null then
    super.free-algebras
  else if super.free-algebras.version == "0.1.0.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/free-algebras-0.1.0.1.patch"
      super.free-algebras)))
  else
    super.free-algebras;

  free-functors = if super.free-functors == null then
    super.free-functors
  else if super.free-functors.version == "1.2.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/free-functors-1.2.1.patch"
      super.free-functors)))
  else
    super.free-functors;

  generic-data = if super.generic-data == null then
    super.generic-data
  else if super.generic-data.version == "0.9.2.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/generic-data-0.9.2.1.patch"
      super.generic-data)))
  else
    super.generic-data;

  generic-lens = if super.generic-lens == null then
    super.generic-lens
  else if super.generic-lens.version == "2.2.0.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/generic-lens-2.2.0.0.patch"
      super.generic-lens)))
  else
    super.generic-lens;

  generic-lens-core = if super.generic-lens-core == null then
    super.generic-lens-core
  else if super.generic-lens-core.version == "2.2.0.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/generic-lens-core-2.2.0.0.patch"
      super.generic-lens-core)))
  else
    super.generic-lens-core;

  generic-optics = if super.generic-optics == null then
    super.generic-optics
  else if super.generic-optics.version == "2.2.0.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/generic-optics-2.2.0.0.patch"
      super.generic-optics)))
  else
    super.generic-optics;

  generics-sop = if super.generics-sop == null then
    super.generics-sop
  else if super.generics-sop.version == "0.5.1.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/generics-sop-0.5.1.1.patch"
      super.generics-sop)))
  else
    super.generics-sop;

  geniplate-mirror = if super.geniplate-mirror == null then
    super.geniplate-mirror
  else if super.geniplate-mirror.version == "0.7.8" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/geniplate-mirror-0.7.8.patch"
      super.geniplate-mirror)))
  else
    super.geniplate-mirror;

  ghc-events = if super.ghc-events == null then
    super.ghc-events
  else if super.ghc-events.version == "0.17.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/ghc-events-0.17.0.patch" super.ghc-events)))
  else
    super.ghc-events;

  happy = if super.happy == null then
    super.happy
  else if super.happy.version == "1.20.0" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/happy-1.20.0.patch"
        super.happy)))
  else
    super.happy;

  haskeline = if super.haskeline == null then
    super.haskeline
  else if super.haskeline.version == "0.7.5.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/haskeline-0.7.5.0.patch" super.haskeline)))
  else
    super.haskeline;

  haskell-src-exts = if super.haskell-src-exts == null then
    super.haskell-src-exts
  else if super.haskell-src-exts.version == "1.23.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/haskell-src-exts-1.23.1.patch"
      super.haskell-src-exts)))
  else
    super.haskell-src-exts;

  haskell-src-meta = if super.haskell-src-meta == null then
    super.haskell-src-meta
  else if super.haskell-src-meta.version == "0.8.7" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/haskell-src-meta-0.8.7.patch"
      super.haskell-src-meta)))
  else
    super.haskell-src-meta;

  haxl = if super.haxl == null then
    super.haxl
  else if super.haxl.version == "2.3.0.0" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/haxl-2.3.0.0.patch"
        super.haxl)))
  else
    super.haxl;

  heterocephalus = if super.heterocephalus == null then
    super.heterocephalus
  else if super.heterocephalus.version == "1.0.5.4" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/heterocephalus-1.0.5.4.patch"
      super.heterocephalus)))
  else
    super.heterocephalus;

  hgeometry = if super.hgeometry == null then
    super.hgeometry
  else if super.hgeometry.version == "0.12.0.4" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/hgeometry-0.12.0.4.patch" super.hgeometry)))
  else
    super.hgeometry;

  hgeometry-combinatorial = if super.hgeometry-combinatorial == null then
    super.hgeometry-combinatorial
  else if super.hgeometry-combinatorial.version == "0.12.0.3" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/hgeometry-combinatorial-0.12.0.3.patch"
      super.hgeometry-combinatorial)))
  else
    super.hgeometry-combinatorial;

  hgeometry-ipe = if super.hgeometry-ipe == null then
    super.hgeometry-ipe
  else if super.hgeometry-ipe.version == "0.12.0.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/hgeometry-ipe-0.12.0.0.patch"
      super.hgeometry-ipe)))
  else
    super.hgeometry-ipe;

  hscolour = if super.hscolour == null then
    super.hscolour
  else if super.hscolour.version == "1.24.4" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/hscolour-1.24.4.patch" super.hscolour)))
  else
    super.hscolour;

  hslogger = if super.hslogger == null then
    super.hslogger
  else if super.hslogger.version == "1.3.1.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/hslogger-1.3.1.0.patch" super.hslogger)))
  else
    super.hslogger;

  hspec-core = if super.hspec-core == null then
    super.hspec-core
  else if super.hspec-core.version == "2.8.4" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/hspec-core-2.8.4.patch" super.hspec-core)))
  else
    super.hspec-core;

  hspec-discover = if super.hspec-discover == null then
    super.hspec-discover
  else if super.hspec-discover.version == "2.8.4" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/hspec-discover-2.8.4.patch"
      super.hspec-discover)))
  else
    super.hspec-discover;

  hspec-expectations = if super.hspec-expectations == null then
    super.hspec-expectations
  else if super.hspec-expectations.version == "0.8.2" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/hspec-expectations-0.8.2.patch"
      super.hspec-expectations)))
  else
    super.hspec-expectations;

  hspec-meta = if super.hspec-meta == null then
    super.hspec-meta
  else if super.hspec-meta.version == "2.7.8" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/hspec-meta-2.7.8.patch" super.hspec-meta)))
  else
    super.hspec-meta;

  hspec-wai = if super.hspec-wai == null then
    super.hspec-wai
  else if super.hspec-wai.version == "0.11.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/hspec-wai-0.11.1.patch" super.hspec-wai)))
  else
    super.hspec-wai;

  http-types = if super.http-types == null then
    super.http-types
  else if super.http-types.version == "0.12.3" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/http-types-0.12.3.patch" super.http-types)))
  else
    super.http-types;

  http2 = if super.http2 == null then
    super.http2
  else if super.http2.version == "3.0.2" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/http2-3.0.2.patch"
        super.http2)))
  else
    super.http2;

  hvect = if super.hvect == null then
    super.hvect
  else if super.hvect.version == "0.4.0.0" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/hvect-0.4.0.0.patch"
        super.hvect)))
  else
    super.hvect;

  hxt = if super.hxt == null then
    super.hxt
  else if super.hxt.version == "9.3.1.22" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/hxt-9.3.1.22.patch"
        super.hxt)))
  else
    super.hxt;

  inj-base = if super.inj-base == null then
    super.inj-base
  else if super.inj-base.version == "0.2.0.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/inj-base-0.2.0.0.patch" super.inj-base)))
  else
    super.inj-base;

  inspection-testing = if super.inspection-testing == null then
    super.inspection-testing
  else if super.inspection-testing.version == "0.4.6.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/inspection-testing-0.4.6.0.patch"
      super.inspection-testing)))
  else
    super.inspection-testing;

  io-choice = if super.io-choice == null then
    super.io-choice
  else if super.io-choice.version == "0.0.7" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/io-choice-0.0.7.patch" super.io-choice)))
  else
    super.io-choice;

  language-c = if super.language-c == null then
    super.language-c
  else if super.language-c.version == "0.9.0.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/language-c-0.9.0.1.patch" super.language-c)))
  else
    super.language-c;

  language-haskell-extract = if super.language-haskell-extract == null then
    super.language-haskell-extract
  else if super.language-haskell-extract.version == "0.2.4" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/language-haskell-extract-0.2.4.patch"
      super.language-haskell-extract)))
  else
    super.language-haskell-extract;

  language-javascript = if super.language-javascript == null then
    super.language-javascript
  else if super.language-javascript.version == "0.7.1.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/language-javascript-0.7.1.0.patch"
      super.language-javascript)))
  else
    super.language-javascript;

  lens = if super.lens == null then
    super.lens
  else if super.lens.version == "5.0.1" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/lens-5.0.1.patch"
        super.lens)))
  else
    super.lens;

  lens-family-th = if super.lens-family-th == null then
    super.lens-family-th
  else if super.lens-family-th.version == "0.5.2.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/lens-family-th-0.5.2.0.patch"
      super.lens-family-th)))
  else
    super.lens-family-th;

  list-t = if super.list-t == null then
    super.list-t
  else if super.list-t.version == "1.0.5" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/list-t-1.0.5.patch"
        super.list-t)))
  else
    super.list-t;

  lockfree-queue = if super.lockfree-queue == null then
    super.lockfree-queue
  else if super.lockfree-queue.version == "0.2.3.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/lockfree-queue-0.2.3.1.patch"
      super.lockfree-queue)))
  else
    super.lockfree-queue;

  memory = if super.memory == null then
    super.memory
  else if super.memory.version == "0.16.0" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/memory-0.16.0.patch"
        super.memory)))
  else
    super.memory;

  monad-validate = if super.monad-validate == null then
    super.monad-validate
  else if super.monad-validate.version == "1.2.0.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/monad-validate-1.2.0.0.patch"
      super.monad-validate)))
  else
    super.monad-validate;

  monadplus = if super.monadplus == null then
    super.monadplus
  else if super.monadplus.version == "1.4.2" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/monadplus-1.4.2.patch" super.monadplus)))
  else
    super.monadplus;

  mono-traversable-keys = if super.mono-traversable-keys == null then
    super.mono-traversable-keys
  else if super.mono-traversable-keys.version == "0.1.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/mono-traversable-keys-0.1.0.patch"
      super.mono-traversable-keys)))
  else
    super.mono-traversable-keys;

  mustache = if super.mustache == null then
    super.mustache
  else if super.mustache.version == "2.3.1" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/mustache-2.3.1.patch"
        super.mustache)))
  else
    super.mustache;

  network = if super.network == null then
    super.network
  else if super.network.version == "3.1.2.5" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/network-3.1.2.5.patch" super.network)))
  else
    super.network;

  obdd = if super.obdd == null then
    super.obdd
  else if super.obdd.version == "0.8.2" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/obdd-0.8.2.patch"
        super.obdd)))
  else
    super.obdd;

  optics-th = if super.optics-th == null then
    super.optics-th
  else if super.optics-th.version == "0.4" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/optics-th-0.4.patch"
        super.optics-th)))
  else
    super.optics-th;

  packman = if super.packman == null then
    super.packman
  else if super.packman.version == "0.5.0" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/packman-0.5.0.patch"
        super.packman)))
  else
    super.packman;

  pandoc = if super.pandoc == null then
    super.pandoc
  else if super.pandoc.version == "2.16.1" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/pandoc-2.16.1.patch"
        super.pandoc)))
  else
    super.pandoc;

  parameterized-utils = if super.parameterized-utils == null then
    super.parameterized-utils
  else if super.parameterized-utils.version == "2.1.4.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/parameterized-utils-2.1.4.0.patch"
      super.parameterized-utils)))
  else
    super.parameterized-utils;

  partial-isomorphisms = if super.partial-isomorphisms == null then
    super.partial-isomorphisms
  else if super.partial-isomorphisms.version == "0.2.3.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/partial-isomorphisms-0.2.3.0.patch"
      super.partial-isomorphisms)))
  else
    super.partial-isomorphisms;

  pem = if super.pem == null then
    super.pem
  else if super.pem.version == "0.2.4" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/pem-0.2.4.patch"
        super.pem)))
  else
    super.pem;

  persistent = if super.persistent == null then
    super.persistent
  else if super.persistent.version == "2.13.2.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/persistent-2.13.2.1.patch"
      super.persistent)))
  else
    super.persistent;

  plots = if super.plots == null then
    super.plots
  else if super.plots.version == "0.1.1.2" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/plots-0.1.1.2.patch"
        super.plots)))
  else
    super.plots;

  posix-api = if super.posix-api == null then
    super.posix-api
  else if super.posix-api.version == "0.3.5.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/posix-api-0.3.5.0.patch" super.posix-api)))
  else
    super.posix-api;

  primitive = if super.primitive == null then
    super.primitive
  else if super.primitive.version == "0.7.3.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/primitive-0.7.3.0.patch" super.primitive)))
  else
    super.primitive;

  primitive-extras = if super.primitive-extras == null then
    super.primitive-extras
  else if super.primitive-extras.version == "0.10.1.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/primitive-extras-0.10.1.1.patch"
      super.primitive-extras)))
  else
    super.primitive-extras;

  primitive-unaligned = if super.primitive-unaligned == null then
    super.primitive-unaligned
  else if super.primitive-unaligned.version == "0.1.1.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/primitive-unaligned-0.1.1.1.patch"
      super.primitive-unaligned)))
  else
    super.primitive-unaligned;

  primitive-unlifted = if super.primitive-unlifted == null then
    super.primitive-unlifted
  else if super.primitive-unlifted.version == "0.1.3.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/primitive-unlifted-0.1.3.0.patch"
      super.primitive-unlifted)))
  else
    super.primitive-unlifted;

  proto3-wire = if super.proto3-wire == null then
    super.proto3-wire
  else if super.proto3-wire.version == "1.2.2" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/proto3-wire-1.2.2.patch" super.proto3-wire)))
  else
    super.proto3-wire;

  relude = if super.relude == null then
    super.relude
  else if super.relude.version == "1.0.0.1" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/relude-1.0.0.1.patch"
        super.relude)))
  else
    super.relude;

  row-types = if super.row-types == null then
    super.row-types
  else if super.row-types.version == "1.0.1.2" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/row-types-1.0.1.2.patch" super.row-types)))
  else
    super.row-types;

  safe = if super.safe == null then
    super.safe
  else if super.safe.version == "0.3.19" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/safe-0.3.19.patch"
        super.safe)))
  else
    super.safe;

  safecopy = if super.safecopy == null then
    super.safecopy
  else if super.safecopy.version == "0.10.4.2" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/safecopy-0.10.4.2.patch" super.safecopy)))
  else
    super.safecopy;

  salak = if super.salak == null then
    super.salak
  else if super.salak.version == "0.3.6" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/salak-0.3.6.patch"
        super.salak)))
  else
    super.salak;

  securemem = if super.securemem == null then
    super.securemem
  else if super.securemem.version == "0.1.10" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/securemem-0.1.10.patch" super.securemem)))
  else
    super.securemem;

  servant = if super.servant == null then
    super.servant
  else if super.servant.version == "0.18.3" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/servant-0.18.3.patch"
        super.servant)))
  else
    super.servant;

  shake = if super.shake == null then
    super.shake
  else if super.shake.version == "0.19.6" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/shake-0.19.6.patch"
        super.shake)))
  else
    super.shake;

  shakespeare = if super.shakespeare == null then
    super.shakespeare
  else if super.shakespeare.version == "2.0.25" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/shakespeare-2.0.25.patch"
      super.shakespeare)))
  else
    super.shakespeare;

  singletons-base = if super.singletons-base == null then
    super.singletons-base
  else if super.singletons-base.version == "3.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/singletons-base-3.0.patch"
      super.singletons-base)))
  else
    super.singletons-base;

  siphash = if super.siphash == null then
    super.siphash
  else if super.siphash.version == "1.0.3" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/siphash-1.0.3.patch"
        super.siphash)))
  else
    super.siphash;

  snap-core = if super.snap-core == null then
    super.snap-core
  else if super.snap-core.version == "1.0.4.2" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/snap-core-1.0.4.2.patch" super.snap-core)))
  else
    super.snap-core;

  streamly = if super.streamly == null then
    super.streamly
  else if super.streamly.version == "0.8.0" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/streamly-0.8.0.patch"
        super.streamly)))
  else
    super.streamly;

  subcategories = if super.subcategories == null then
    super.subcategories
  else if super.subcategories.version == "0.1.1.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/subcategories-0.1.1.0.patch"
      super.subcategories)))
  else
    super.subcategories;

  test-framework = if super.test-framework == null then
    super.test-framework
  else if super.test-framework.version == "0.8.2.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/test-framework-0.8.2.0.patch"
      super.test-framework)))
  else
    super.test-framework;

  text-format = if super.text-format == null then
    super.text-format
  else if super.text-format.version == "0.3.2" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/text-format-0.3.2.patch" super.text-format)))
  else
    super.text-format;

  th-desugar = if super.th-desugar == null then
    super.th-desugar
  else if super.th-desugar.version == "1.12" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/th-desugar-1.12.patch" super.th-desugar)))
  else
    super.th-desugar;

  th-extras = if super.th-extras == null then
    super.th-extras
  else if super.th-extras.version == "0.0.0.4" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/th-extras-0.0.0.4.patch" super.th-extras)))
  else
    super.th-extras;

  threads = if super.threads == null then
    super.threads
  else if super.threads.version == "0.5.1.6" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/threads-0.5.1.6.patch" super.threads)))
  else
    super.threads;

  tls = if super.tls == null then
    super.tls
  else if super.tls.version == "1.5.5" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/tls-1.5.5.patch"
        super.tls)))
  else
    super.tls;

  tpdb = if super.tpdb == null then
    super.tpdb
  else if super.tpdb.version == "2.2.0" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/tpdb-2.2.0.patch"
        super.tpdb)))
  else
    super.tpdb;

  tree-diff = if super.tree-diff == null then
    super.tree-diff
  else if super.tree-diff.version == "0.2.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/tree-diff-0.2.1.patch" super.tree-diff)))
  else
    super.tree-diff;

  true-name = if super.true-name == null then
    super.true-name
  else if super.true-name.version == "0.1.0.3" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/true-name-0.1.0.3.patch" super.true-name)))
  else
    super.true-name;

  uniplate = if super.uniplate == null then
    super.uniplate
  else if super.uniplate.version == "1.6.13" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/uniplate-1.6.13.patch" super.uniplate)))
  else
    super.uniplate;

  unordered-containers = if super.unordered-containers == null then
    super.unordered-containers
  else if super.unordered-containers.version == "0.2.14.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/unordered-containers-0.2.14.0.patch"
      super.unordered-containers)))
  else
    super.unordered-containers;

  validity = if super.validity == null then
    super.validity
  else if super.validity.version == "0.11.0.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/validity-0.11.0.1.patch" super.validity)))
  else
    super.validity;

  vector-builder = if super.vector-builder == null then
    super.vector-builder
  else if super.vector-builder.version == "0.3.8.2" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/vector-builder-0.3.8.2.patch"
      super.vector-builder)))
  else
    super.vector-builder;

  vector-circular = if super.vector-circular == null then
    super.vector-circular
  else if super.vector-circular.version == "0.1.3" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/vector-circular-0.1.3.patch"
      super.vector-circular)))
  else
    super.vector-circular;

  vinyl = if super.vinyl == null then
    super.vinyl
  else if super.vinyl.version == "0.13.3" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/vinyl-0.13.3.patch"
        super.vinyl)))
  else
    super.vinyl;

  vty = if super.vty == null then
    super.vty
  else if super.vty.version == "5.33" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/vty-5.33.patch"
        super.vty)))
  else
    super.vty;

  wai-app-static = if super.wai-app-static == null then
    super.wai-app-static
  else if super.wai-app-static.version == "3.1.7.2" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/wai-app-static-3.1.7.2.patch"
      super.wai-app-static)))
  else
    super.wai-app-static;

  wai-extra = if super.wai-extra == null then
    super.wai-extra
  else if super.wai-extra.version == "3.1.7" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/wai-extra-3.1.7.patch" super.wai-extra)))
  else
    super.wai-extra;

  warp = if super.warp == null then
    super.warp
  else if super.warp.version == "3.3.17" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/warp-3.3.17.patch"
        super.warp)))
  else
    super.warp;

  wide-word = if super.wide-word == null then
    super.wide-word
  else if super.wide-word.version == "0.1.1.2" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/wide-word-0.1.1.2.patch" super.wide-word)))
  else
    super.wide-word;

  winery = if super.winery == null then
    super.winery
  else if super.winery.version == "1.3.2" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/winery-1.3.2.patch"
        super.winery)))
  else
    super.winery;

  x509 = if super.x509 == null then
    super.x509
  else if super.x509.version == "1.7.5" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/x509-1.7.5.patch"
        super.x509)))
  else
    super.x509;

  x509-validation = if super.x509-validation == null then
    super.x509-validation
  else if super.x509-validation.version == "1.6.11" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/x509-validation-1.6.11.patch"
      super.x509-validation)))
  else
    super.x509-validation;

  xlsx = if super.xlsx == null then
    super.xlsx
  else if super.xlsx.version == "0.8.4" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/xlsx-0.8.4.patch"
        super.xlsx)))
  else
    super.xlsx;

  xml-hamlet = if super.xml-hamlet == null then
    super.xml-hamlet
  else if super.xml-hamlet.version == "0.5.0.1" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/xml-hamlet-0.5.0.1.patch" super.xml-hamlet)))
  else
    super.xml-hamlet;

  yaml = if super.yaml == null then
    super.yaml
  else if super.yaml.version == "0.11.7.0" then
    (haskellLib.doJailbreak (dontRevise
      (haskellLib.appendPatch "${head-hackage-src}/patches/yaml-0.11.7.0.patch"
        super.yaml)))
  else
    super.yaml;

  yesod-core = if super.yesod-core == null then
    super.yesod-core
  else if super.yesod-core.version == "1.6.21.0" then
    (haskellLib.doJailbreak (dontRevise (haskellLib.appendPatch
      "${head-hackage-src}/patches/yesod-core-1.6.21.0.patch"
      super.yesod-core)))
  else
    super.yesod-core;

}
