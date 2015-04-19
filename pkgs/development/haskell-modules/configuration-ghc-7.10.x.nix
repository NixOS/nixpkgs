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

  # should be fixed in versions > 1.13.2
  pandoc = overrideCabal super.pandoc (drv: {
    patches = [
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc/commit/693f9ab.patch";
         sha256 = "1niyrigs47ia1bhk6yrnzf0sq7hz5b7xisc8ph42wkp5sl8x9h1y";
      })
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc/commit/9c68017.patch";
         sha256 = "0zccb6l5vmfyq7p8ii88fgggfhrff32hj43f5pp3w88l479f1qlh";
      })
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc/commit/dbe1b38.patch";
         sha256 = "0d80692liyjx2y56w07k23adjcxb57w6vzcylmc4cfswzy8agrgy";
      })
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc/commit/5ea3856.patch";
         sha256 = "1z15lc0ix9fv278v1xmfw3a6gl85ydahgs8kz61sfvh4jdiacabw";
      })
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc/commit/c80c9ac.patch";
         sha256 = "0fk3j53zx0x88jmh0ism0aghs2w5qf87zcp9cwbfcgg5izh3b344";
      })
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc/commit/8b9bded.patch";
         sha256 = "0f1dh1jmhq55mlv4dawvx3ck330y82qmys06bfkqcpl0jsyd9x1a";
      })
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc/commit/e4c7894.patch";
         sha256 = "1rfdaq6swrl3m9bmbf6yhqq57kv3l3f4927xya3zq29dpvkmmi4z";
      })
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc/commit/2a6f68f.patch";
         sha256 = "0sbh2x9jqvis9ln8r2dr6ihkjdn480mjskm4ny91870vg852228c";
      })
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc/commit/4e3281c.patch";
         sha256 = "0zafhxxijli2mf1h0j7shp7kd7fxqbvlswm1m8ikax3aknvjxymi";
      })
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc/commit/cd5b1fe.patch";
         sha256 = "0nxq7c0gpdiycgdrcj3llbfwxdni6k7hqqniwsbn2ha3h03i8hg1";
      })
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc/commit/ed7606d.patch";
         sha256 = "0gchm46ziyj7vw6ibn3kk49cjzsc78z2lm8k7892g79q2livlc1f";
      })
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc/commit/b748833.patch";
         sha256 = "03gj4qn9c5zyqrxyrw4xh21xlvbx9rbvw6gh8msgf5xk53ibs68b";
      })
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc/commit/10d5398.patch";
         sha256 = "1nhp5b07vywk917bfap6pzahhqnwvvlbbfg5336a2nvb0c8iq6ih";
      })
      (pkgs.fetchpatch {
         url = "https://github.com/jgm/pandoc/commit/f18ceb1.patch";
         sha256 = "1vxsy5fn4nscvim9wcx1n78q7yh05x0z8p812csi3v3z79lbabhq";
      })
    ];
    # jailbreak-cabal omits part of the file
    # https://github.com/peti/jailbreak-cabal/issues/9
    postPatch = ''
      sed -i '420i\ \ \ \ \ \ \ \ \ \ \ \ buildable: False' pandoc.cabal
    '';
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
  arithmoi = appendPatch super.arithmoi (pkgs.fetchpatch {
    url = "https://github.com/cartazio/arithmoi/pull/3.patch";
    sha256 = "1rqs796sh81inqkg2vadskcjpp6q92j6k8zpn370990wndndzzmq";
  });
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

}
