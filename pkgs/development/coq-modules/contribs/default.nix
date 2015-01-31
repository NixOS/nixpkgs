contribs:

let
  mkContrib = import ./mk-contrib.nix;
  all = import ./all.nix;
  overrides = {
    BDDs = self: {
      buildInputs = self.buildInputs ++ [ contribs.IntMap ];
      patchPhase = ''
        patch Make <<EOF
        2d1
        < -R ../../Cachan/IntMap IntMap
        32d30
        < extraction
        EOF
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
      '';
    };
    CoRN = self: {
      buildInputs = self.buildInputs ++ [ contribs.MathClasses ];
      patchPhase = ''
        patch Make <<EOF
        2d1
        < -R ../MathClasses/ MathClasses
        EOF
      '';
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
      '';
    };
    FingerTree = self: {
      patchPhase = ''
        patch Make <<EOF
        21d20
        < extraction
        EOF
      '';
    };
    Goedel = self: {
      buildInputs = self.buildInputs ++ [ contribs.Pocklington ];
      patchPhase = ''
        patch Make <<EOF
        2d1
	< -R ../../Eindhoven/Pocklington Pocklington
        EOF
      '';
    };
    Graphs = self: {
      buildInputs = self.buildInputs ++ [ contribs.IntMap ];
      patchPhase = ''
        patch Make <<EOF
        2d1
        < -R ../../Cachan/IntMap IntMap
        EOF
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
      '';
    };
    PTSF = self: {
      buildInputs = self.buildInputs ++ [ contribs.PTSATR ];
      patchPhase = ''
        patch Make <<EOF
        1d0
        < -R ../../Paris/PTSATR/ PTSATR
        EOF
      '';
    };
    RelationExtraction = self: {
      patchPhase = ''
        patch Make <<EOF
        31d30
        < test
        EOF
      '';
    };
    SMC = self: {
      buildInputs = self.buildInputs ++ [ contribs.IntMap ];
      patchPhase = ''
        patch Make <<EOF
        2d1
        < -R ../../Cachan/IntMap IntMap
        EOF
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
      '';
    };
    TreeAutomata = self: {
      buildInputs = self.buildInputs ++ [ contribs.IntMap ];
      patchPhase = ''
        patch Make <<EOF
        2d1
        < -R ../../Cachan/IntMap IntMap
        EOF
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
