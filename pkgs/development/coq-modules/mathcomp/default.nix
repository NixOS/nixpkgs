{ stdenv, fetchFromGitHub, ncurses, which, graphviz, coq,
  recurseIntoAttrs, withDoc ? false
}:
with builtins // stdenv.lib;
let
  ####################################
  # CONFIGURATION (please edit this) #
  ####################################
  # sha256 of released mathcomp versions
  mathcomp-sha256 = {
    "1.10.0" = "1b9m6pwxxyivw7rgx82gn5kmgv2mfv3h3y0mmjcjfypi8ydkrlbv";
    "1.9.0" = "0lid9zaazdi3d38l8042lczb02pw5m9wq0yysiilx891hgq2p81r";
    "1.8.0" = "07l40is389ih8bi525gpqs3qp4yb2kl11r9c8ynk1ifpjzpnabwp";
    "1.7.0" = "0wnhj9nqpx2bw6n1l4i8jgrw3pjajvckvj3lr4vzjb3my2lbxdd1";
    "1.6.1" = "1ilw6vm4dlsdv9cd7kmf0vfrh2kkzr45wrqr8m37miy0byzr4p9i";
  };
  # versions of coq compatible with released mathcomp versions
  mathcomp-coq-versions = {
    "1.10.0" = flip elem [ "8.7" "8.8" "8.9" "8.10" "8.11" ];
    "1.9.0" = flip elem ["8.7" "8.8" "8.9" "8.10"];
    "1.8.0" = flip elem ["8.7" "8.8" "8.9"];
    "1.7.0" = flip elem ["8.6" "8.7" "8.8" "8.9"];
    "1.6.1" = flip elem ["8.5"];
  };
  # computes the default version of mathcomp given a version of Coq
  max-mathcomp-version = last (naturalSort (attrNames mathcomp-coq-versions));
  # mathcomp prefered version by decreasing order
  # (the first version in the list will be tried first)
  mathcomp-version-preference = [ "1.8.0" "1.9.0" "1.10.0" "1.7.0" "1.6.1" ];

  ##############################################################
  # COMPUTED using the configuration above (edit with caution) #
  ##############################################################
  default-mathcomp-version = let v = head (
    filter (mc: mathcomp-coq-versions.${mc} coq.coq-version)
            mathcomp-version-preference ++ ["0.0.0"]);
     in if v == "0.0.0" then max-mathcomp-version else v;

  # list of core mathcomp packages sorted by dependency order
  mathcomp-packages =
    [ "ssreflect" "fingroup" "algebra" "solvable" "field" "character" "all" ];
  # compute the dependencies of the core package pkg
  # (assuming the total ordering above, rewrite if necessary)
  mathcomp-deps = pkg: if pkg == "single" then [] else
    (split (x: x == pkg) mathcomp-packages).left;

  # generic split function (TODO: move to lib?)
  split = pred: l:
    let loop = v: l: if l == [] then {left = v; right = [];}
      else let hd = builtins.head l; tl = builtins.tail l; in
      if pred hd then {left = v; right = tl;} else loop (v ++ [hd]) tl;
    in loop [] l;

  # exported, documented at the end.
  mathcompGen = mkMathcompGenFrom (_: {}) mathcomp-packages;

  # exported, documented at the end.
  mathcompGenSingle = mkMathcompGen (_: {}) "single";

  # mkMathcompGen: internal mathcomp package generator
  # returns {error = ...} if impossible to generate
  # returns {${mathcomp-pkg} = <derivation>} otherwise
  mkMathcompGenFrom = o: l: mcv: fold (pkg: pkgs: pkgs // mkMathcompGen o pkg mcv) {} l;
  mkMathcompGen = overrides: mathcomp-pkg: mathcomp-version:
    let
      coq-version-check = mathcomp-coq-versions.${mathcomp-version} or (_: false);
      pkgpath = {single = "mathcomp";}.${mathcomp-pkg} or "mathcomp/${mathcomp-pkg}";
      pkgname = {single = "mathcomp";}.${mathcomp-pkg} or "mathcomp-${mathcomp-pkg}";
      pkgallMake = ''
      echo "all.v" > Make
      echo "-I ." >> Make
      echo "-R . mathcomp.all" >> Make
      '';
      is-released = builtins.isString mathcomp-version;
      custom-version = if is-released then mathcomp-version else "custom";

      # the base set of attributes for mathcomp
      attrs = {
        name = "coq${coq.coq-version}-${pkgname}-${custom-version}";

        # used in ssreflect
        version = custom-version;

        src = if is-released then fetchFromGitHub {
          owner = "math-comp";
          repo = "math-comp";
          rev = "mathcomp-${mathcomp-version}";
          sha256 = mathcomp-sha256.${mathcomp-version};
        } else mathcomp-version;

        nativeBuildInputs = optionals withDoc [ graphviz ];
        buildInputs = [ ncurses which ] ++ (with coq.ocamlPackages; [ ocaml findlib camlp5 ]);
        propagatedBuildInputs = [ coq ] ++
           attrValues (mkMathcompGenFrom overrides (mathcomp-deps mathcomp-pkg) mathcomp-version);
        enableParallelBuilding = true;

        buildFlags = optional withDoc "doc";

        COQBIN = "${coq}/bin/";

        preBuild = ''
          patchShebangs etc/utils/ssrcoqdep || true
          cd ${pkgpath}
        '' + optionalString (mathcomp-pkg == "all") pkgallMake;

        installPhase = ''
          make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
        '' + optionalString withDoc ''
          make -f Makefile.coq install-doc DOCDIR=$out/share/coq/${coq.coq-version}/
        '';

        meta = with stdenv.lib; {
          homepage = "https://math-comp.github.io/";
          license = licenses.cecill-b;
          maintainers = [ maintainers.vbgl maintainers.jwiegley ];
          platforms = coq.meta.platforms;
        };

        passthru = {
          compatibleCoqVersions = coq-version-check;
          currentOverrides = overrides;
          overrideMathcomp = moreOverrides:
            (mkMathcompGen (old: let new = overrides old; in new // moreOverrides new)
                          mathcomp-pkg mathcomp-version).${mathcomp-pkg};
          mathcompGen = moreOverrides:
            (mkMathcompGenFrom (old: let new = overrides old; in new // moreOverrides new)
                          mathcomp-packages mathcomp-version);
        };
      };
    in
    {${mathcomp-pkg} = stdenv.mkDerivation (attrs // overrides attrs);};

getAttrOr = a: n: a.${n} or (throw a.error);

mathcompCorePkgs_1_7 = mathcompGen "1.7.0";
mathcompCorePkgs_1_8 = mathcompGen "1.8.0";
mathcompCorePkgs_1_9 = mathcompGen "1.9.0";
mathcompCorePkgs_1_10 = mathcompGen "1.10.0";
mathcompCorePkgs     = recurseIntoAttrs
  (mapDerivationAttrset dontDistribute (mathcompGen default-mathcomp-version));

in {
# mathcompGenSingle: given a version of mathcomp
# generates an attribute set {single = <drv>;} with the single mathcomp derivation
inherit mathcompGenSingle;
mathcomp_1_7_single = getAttrOr (mathcompGenSingle "1.7.0") "single";
mathcomp_1_8_single = getAttrOr (mathcompGenSingle "1.8.0") "single";
mathcomp_1_9_single = getAttrOr (mathcompGenSingle "1.9.0") "single";
mathcomp_1_10_single = getAttrOr (mathcompGenSingle "1.10.0") "single";
mathcomp_single     = dontDistribute
 (getAttrOr (mathcompGenSingle default-mathcomp-version) "single");

# mathcompGen: given a version of mathcomp
# generates an attribute set {ssreflect = <drv>; ... character = <drv>; all = <drv>;}.
# each of these have a special attribute overrideMathcomp which
# must be used instead of overrideAttrs in order to also fix the dependencies
inherit mathcompGen mathcompCorePkgs
        mathcompCorePkgs_1_7 mathcompCorePkgs_1_8 mathcompCorePkgs_1_9
	mathcompCorePkgs_1_10
	;


mathcomp     = getAttrOr mathcompCorePkgs     "all";
mathcomp_1_7 = getAttrOr mathcompCorePkgs_1_7 "all";
mathcomp_1_8 = getAttrOr mathcompCorePkgs_1_8 "all";
mathcomp_1_9 = getAttrOr mathcompCorePkgs_1_9 "all";
mathcomp_1_10 = getAttrOr mathcompCorePkgs_1_10 "all";

ssreflect     = getAttrOr mathcompCorePkgs    "ssreflect";

} //
(mapAttrs' (n: pkg: {name = "mathcomp-${n}"; value = pkg;}) mathcompCorePkgs) //
(mapAttrs' (n: pkg: {name = "mathcomp-${n}_1_7"; value = pkg;}) mathcompCorePkgs_1_7) //
(mapAttrs' (n: pkg: {name = "mathcomp-${n}_1_8"; value = pkg;}) mathcompCorePkgs_1_8) //
(mapAttrs' (n: pkg: {name = "mathcomp-${n}_1_9"; value = pkg;}) mathcompCorePkgs_1_9) //
(mapAttrs' (n: pkg: {name = "mathcomp-${n}_1_10"; value = pkg;}) mathcompCorePkgs_1_10)
