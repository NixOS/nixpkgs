contribs:

let
  mkContrib = import ./mk-contrib.nix;
  all = import ./all.nix;
  overrides = {
    Additions = self: {
      patchPhase = ''
        for p in binary_strat dicho_strat generation log2_implementation shift
        do
          substituteInPlace $p.v \
          --replace 'Require Import Euclid.' 'Require Import Coq.Arith.Euclid.'
        done
      '';
    };
    BDDs = self: {
      buildInputs = self.buildInputs ++ [ contribs.IntMap ];
      patchPhase = ''
        patch Make <<EOF
        2d1
        < -R ../../Cachan/IntMap IntMap
        32d30
        < extraction
        EOF
        coq_makefile -f Make -o Makefile
      '';
      postInstall = ''
        mkdir -p $out/bin
        cp extraction/dyade $out/bin
      '';
    };
    CanonBDDs = self: {
      patchPhase = ''
        patch Make <<EOF
        17d16
        < rauzy/algorithme1/extraction
        EOF
        coq_makefile -f Make -o Makefile
      '';
      postInstall = ''
        mkdir -p $out/bin
        cp rauzy/algorithme1/extraction/suresnes $out/bin
      '';
    };
    CoinductiveReals = self: {
      buildInputs = self.buildInputs ++ [ contribs.QArithSternBrocot ];
      patchPhase = ''
        patch Make <<EOF
        2d1
        < -R ../QArithSternBrocot QArithSternBrocot
        EOF
        coq_makefile -f Make -o Makefile
      '';
    };
    CoRN = self: {
      buildInputs = self.buildInputs ++ [ contribs.MathClasses ];
      patchPhase = ''
        patch Make <<EOF
        2d1
        < -R ../MathClasses/ MathClasses
        EOF
        coq_makefile -f Make -o Makefile.coq
      '';
      enableParallelBuilding = true;
      installFlags = self.installFlags + " -f Makefile.coq";
    };
    Counting = self: {
      postInstall = ''
        for ext in cma cmxs
        do
          cp src/counting_plugin.$ext $out/lib/coq/8.4/user-contrib/Counting/
        done
      '';
    };
    Ergo = self: {
      buildInputs = self.buildInputs ++ (with contribs; [ Containers Counting Nfix ]);
      patchPhase = ''
        patch Make <<EOF
        4,9d3
        < -I ../Containers/src
        < -R ../Containers/theories Containers
        < -I ../Nfix/src
        < -R ../Nfix/theories Nfix
        < -I ../Counting/src
        < -R ../Counting/theories Counting
        EOF
        coq_makefile -f Make -o Makefile
      '';
    };
    FingerTree = self: {
      patchPhase = ''
        patch Make <<EOF
        21d20
        < extraction
        EOF
        coq_makefile -f Make -o Makefile
      '';
    };
    FOUnify = self: {
      patchPhase = ''
        patch Make <<EOF
        8c8
        < -custom "\$(CAMLOPTLINK) -pp '\$(CAMLBIN)\$(CAMLP4)o' -o unif unif.mli unif.ml main.ml" unif.ml unif
        ---
        > -custom "\$(CAMLOPTLINK) -pp 'camlp5o' -o unif unif.mli unif.ml main.ml" unif.ml unif
        EOF
        coq_makefile -f Make -o Makefile
      '';
      postInstall = ''
        mkdir -p $out/bin
        cp unif $out/bin/
      '';
    };
    Goedel = self: {
      buildInputs = self.buildInputs ++ [ contribs.Pocklington ];
      patchPhase = ''
        patch Make <<EOF
        2d1
        < -R ../../Eindhoven/Pocklington Pocklington
        EOF
        coq_makefile -f Make -o Makefile
      '';
    };
    Graphs = self: {
      buildInputs = self.buildInputs ++ [ contribs.IntMap ];
      patchPhase = ''
        patch Make <<EOF
        2d1
        < -R ../../Cachan/IntMap IntMap
        EOF
        coq_makefile -f Make -o Makefile
      '';
      postInstall = ''
        mkdir -p $out/bin
        cp checker $out/bin/
      '';
    };
    IntMap = self: { configurePhase = "coq_makefile -f Make -o Makefile"; };
    LinAlg = self: {
      buildInputs = self.buildInputs ++ [ contribs.Algebra ];
      patchPhase = ''
        patch Make <<EOF
        2d1
        < -R ../../Sophia-Antipolis/Algebra/ Algebra
        EOF
        coq_makefile -f Make -o Makefile
      '';
    };
    Markov = self: { configurePhase = "coq_makefile -o Makefile -R . Markov markov.v"; };
    Nfix = self: {
      postInstall = ''
        for ext in cma cmxs
        do
          cp src/nfix_plugin.$ext $out/lib/coq/8.4/user-contrib/Nfix/
        done
      '';
    };
    OrbStab = self: {
      buildInputs = self.buildInputs ++ (with contribs; [ LinAlg Algebra ]);
      patchPhase = ''
        patch Make <<EOF
        2,3d1
        < -R ../../Sophia-Antipolis/Algebra Algebra
        < -R ../../Nijmegen/LinAlg LinAlg
        EOF
        coq_makefile -f Make -o Makefile
      '';
    };
    PTSF = self: {
      buildInputs = self.buildInputs ++ [ contribs.PTSATR ];
      patchPhase = ''
        patch Make <<EOF
        1d0
        < -R ../../Paris/PTSATR/ PTSATR
        EOF
        coq_makefile -f Make -o Makefile
      '';
    };
    RelationExtraction = self: {
      patchPhase = ''
        patch Make <<EOF
        31d30
        < test
        EOF
        coq_makefile -f Make -o Makefile
      '';
    };
    Semantics = self: {
      patchPhase = ''
        patch Make <<EOF
        18a19
        > interp.mli
        EOF
      '';
      configurePhase = ''
        coq_makefile -f Make -o Makefile
        make extract_interpret.vo
        rm -f str_little.ml.d
      '';
    };
    SMC = self: {
      buildInputs = self.buildInputs ++ [ contribs.IntMap ];
      patchPhase = ''
        patch Make <<EOF
        2d1
        < -R ../../Cachan/IntMap IntMap
        EOF
        coq_makefile -f Make -o Makefile
      '';
    };
    Ssreflect = self: {
      patchPhase = ''
        substituteInPlace Makefile \
        --replace "/bin/mkdir" "mkdir"
      '';
    };
    Stalmarck = self: {
      configurePhase = "coq_makefile -R . Stalmarck *.v staltac.ml4 > Makefile";
    };
    Topology = self: {
      buildInputs = self.buildInputs ++ [ contribs.ZornsLemma ];
      patchPhase = ''
        patch Make <<EOF
        2d1
        < -R ../ZornsLemma ZornsLemma
        EOF
        coq_makefile -f Make -o Makefile
      '';
    };
    TreeAutomata = self: {
      buildInputs = self.buildInputs ++ [ contribs.IntMap ];
      patchPhase = ''
        patch Make <<EOF
        2d1
        < -R ../../Cachan/IntMap IntMap
        EOF
        coq_makefile -f Make -o Makefile
      '';
    };
  };
in

callPackage: extra:

builtins.listToAttrs (
map
(name:
  let
    sha256 = builtins.getAttr name all;
    override =
      if builtins.hasAttr name overrides
      then builtins.getAttr name overrides
      else x: { };
  in
  {
    inherit name;
    value = callPackage (mkContrib { inherit name sha256 override; }) extra;
  }
)
(builtins.attrNames all)
)
