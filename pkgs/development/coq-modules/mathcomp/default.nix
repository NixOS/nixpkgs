#############################
# Main derivation: mathcomp #
########################################################################
# This file mainly provides the `mathcomp` derivation, which is        #
# essentially a meta-package containing all core mathcomp libraries    #
# (ssreflect fingroup algebra solvable field character). They can be   #
# accessed individually through the paththrough attributes of mathcomp #
# bearing the same names (mathcomp.ssreflect, etc).                    #
#                                                                      #
# Do not use overrideAttrs, but overrideMathcomp instead, which        #
# regenerate a full mathcomp derivation with sub-derivations, and      #
# behave the same as `mathcomp_`, described below.                     #
########################################################################

############################################################
# Compiling a custom version of mathcomp using `mathcomp_` #
##############################################################################
# The prefered way to compile a custom version of mathcomp (other than a     #
# released version which should be added to `mathcomp-config-initial`        #
# and pushed to nixpkgs), is to apply the function `coqPackages.mathcomp_`   #
# to either:                                                                 #
# - a string without slash, which is interpreted as a github revision,       #
#   i.e. either a tag, a branch or a commit hash                             #
# - a string with slashes "owner/p_1/.../p_n", which is interpreted as       #
#   github owner "owner" and revision "p_1/.../p_n".                         #
# - a path which is interpreted as a local source for the repository,        #
#   the name of the version is taken to be the basename of the path          #
#   i.e. if the path is /home/you/git/package/branch/,                       #
#        then "branch" is the name of the version                            #
# - an attribute set which overrides some attributes (e.g. the src)          #
#   if the version is updated, the name is automatically regenerated using   #
#   the conventional schema "coq${coq.coq-version}-${pkgname}-${version}"    #
# - a "standard" override function (old: new_attrs) to override the default  #
#   attribute set, so that you can use old.${field} to patch the derivation. #
##############################################################################

#########################################################################
# Example of use: https://github.com/math-comp/math-comp/wiki/Using-nix #
#########################################################################

#################################
# Adding a new mathcomp version #
#############################################################################
# When adding a new version of mathcomp, add an attribute to `sha256` (use  #
# ```sh                                                                     #
# nix-prefetch-url --unpack                                                 #
# https://github.com/math-comp/math-comp/archive/version.tar.gz             #
# ```                                                                       #
# to get the corresponding `sha256`) and to `coq-version` (read the release #
# notes to check which versions of coq it is compatible with). Then add     #
# it in `preference version`, if not all mathcomp-extra packages are        #
# ready, you might want to give new release secondary priority.             #
#############################################################################


{ stdenv, fetchFromGitHub, ncurses, which, graphviz,
  recurseIntoAttrs, withDoc ? false,
  coqPackages,
  mathcomp_, mathcomp, mathcomp-config,
}:
with builtins // stdenv.lib;
let
  mathcomp-config-initial = rec {
  #######################################################################
  # CONFIGURATION (please edit this), it is exported as mathcomp-config #
  #######################################################################
    # sha256 of released mathcomp versions
    sha256 = {
      "1.12.0"       = "1ccfny1vwgmdl91kz5xlmhq4wz078xm4z5wpd0jy5rn890dx03wp";
      "1.11.0"       = "06a71d196wd5k4wg7khwqb7j7ifr7garhwkd54s86i0j7d6nhl3c";
      "1.11+beta1"   = "12i3zznwajlihzpqsiqniv20rklj8d8401lhd241xy4s21fxkkjm";
      "1.10.0"       = "1b9m6pwxxyivw7rgx82gn5kmgv2mfv3h3y0mmjcjfypi8ydkrlbv";
      "1.9.0"        = "0lid9zaazdi3d38l8042lczb02pw5m9wq0yysiilx891hgq2p81r";
      "1.8.0"        = "07l40is389ih8bi525gpqs3qp4yb2kl11r9c8ynk1ifpjzpnabwp";
      "1.7.0"        = "0wnhj9nqpx2bw6n1l4i8jgrw3pjajvckvj3lr4vzjb3my2lbxdd1";
      "1.6.1"        = "1ilw6vm4dlsdv9cd7kmf0vfrh2kkzr45wrqr8m37miy0byzr4p9i";
    };
    # versions of coq compatible with released mathcomp versions
    coq-versions     = {
      "1.12.0"       = flip elem [ "8.13" ];
      "1.11.0"       = flip elem [ "8.7" "8.8" "8.9" "8.10" "8.11" "8.12" ];
      "1.11+beta1"   = flip elem [ "8.7" "8.8" "8.9" "8.10" "8.11" "8.12" ];
      "1.10.0"       = flip elem [ "8.7" "8.8" "8.9" "8.10" "8.11" ];
      "1.9.0"        = flip elem [ "8.7" "8.8" "8.9" "8.10" ];
      "1.8.0"        = flip elem [ "8.7" "8.8" "8.9" ];
      "1.7.0"        = flip elem [ "8.6" "8.7" "8.8" "8.9" ];
      "1.6.1"        = flip elem [ "8.5"];
    };

    # sets the default version of mathcomp given a version of Coq
    # this is currently computed using version-perference below
    # but it can be set to a fixed version number
    preferred-version = let v = head (
      filter (mc: mathcomp-config.coq-versions.${mc} coq.coq-version)
        mathcomp-config.version-preferences ++ ["0.0.0"]);
     in if v == "0.0.0" then head mathcomp-config.version-preferences else v;

    # mathcomp preferred versions by decreasing order
    # (the first version in the list will be tried first)
    version-preferences =
      [ "1.12.0" "1.10.0" "1.11.0" "1.9.0" "1.8.0" "1.7.0" "1.6.1" ];

    # list of core mathcomp packages sorted by dependency order
    packages = _version: # unused in current versions of mathcomp
      # because the following list of packages is fixed for
      # all versions of mathcomp up to 1.11.0
      [ "ssreflect" "fingroup" "algebra" "solvable" "field" "character" "all" ];

    # compute the dependencies of the core package pkg
    # (assuming the total ordering above, change if necessary)
    deps = version: pkg: if pkg == "single" then [] else
      (pred-split-list (x: x == pkg) (mathcomp-config.packages version)).left;
  };

  ##############################################################
  # COMPUTED using the configuration above (edit with caution) #
  ##############################################################

  # generic split function (TODO: move to lib?)
  pred-split-list = pred: l:
    let loop = v: l: if l == [] then {left = v; right = [];}
      else let hd = builtins.head l; tl = builtins.tail l; in
      if pred hd then {left = v; right = tl;} else loop (v ++ [hd]) tl;
    in loop [] l;

  pkgUp = l: r: l // r // {
    meta     = (l.meta or {}) // (r.meta or {});
    passthru = (l.passthru or {}) // (r.passthru or {});
  };

  coq = coqPackages.coq;
  mathcomp-deps = mathcomp-config.deps mathcomp.config.preferred-version;

  # default set of attributes given a 'package' name.
  # this attribute set will be extended using toOverrideFun
  default-attrs = package:
    let
      pkgpath = if package == "single" then "mathcomp" else "mathcomp/${package}";
      pkgname = if package == "single" then "mathcomp" else "mathcomp-${package}";
      pkgallMake = ''
        echo "all.v"  > Make
        echo "-I ." >>   Make
        echo "-R . mathcomp.all" >> Make
      '';
    in
      rec {
        version = "master";
        name = "coq${coq.coq-version}-${pkgname}-${version}";

        nativeBuildInputs = optionals withDoc [ graphviz ];
        buildInputs = [ ncurses which ] ++ (with coq.ocamlPackages; [ ocaml findlib camlp5 ]);
        propagatedBuildInputs = [ coq ];
        enableParallelBuilding = true;

        buildFlags = optional withDoc "doc";

        COQBIN = "${coq}/bin/";

        preBuild = ''
          patchShebangs etc/utils/ssrcoqdep || true
          cd ${pkgpath}
        '' + optionalString (package == "all") pkgallMake;

        installPhase = ''
          make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
        '' + optionalString withDoc ''
          make -f Makefile.coq install-doc DOCDIR=$out/share/coq/${coq.coq-version}/
        '';

        meta = with stdenv.lib; {
          homepage    = "https://math-comp.github.io/";
          license     = licenses.cecill-b;
          maintainers = [ maintainers.vbgl maintainers.jwiegley maintainers.cohencyril ];
          platforms   = coq.meta.platforms;
        };

        passthru = {
          mathcompDeps = mathcomp-deps package;
          inherit package mathcomp-config;
          compatibleCoqVersions = _: true;
        };
      };

  # converts a string, path or attribute set into an override function
  toOverrideFun = overrides:
    if isFunction overrides then overrides else old:
      let
          pkgname = if old.passthru.package == "single" then "mathcomp"
                    else "mathcomp-${old.passthru.package}";

          string-attrs = if hasAttr overrides mathcomp-config.sha256 then
                let version = overrides;
                in {
                  inherit version;
                  src = fetchFromGitHub {
                    owner  = "math-comp";
                    repo   = "math-comp";
                    rev    = "mathcomp-${version}";
                    sha256 = mathcomp-config.sha256.${version};
                  };
                  passthru = old.passthru // {
                    compatibleCoqVersions = mathcomp-config.coq-versions.${version};
                    mathcompDeps = mathcomp-config.deps version old.passthru.package;
                  };
                }
              else
                let splitted = filter isString (split "/" overrides);
                    owner    = head splitted;
                    ref      = concatStringsSep "/" (tail splitted);
                    version  = head (reverseList splitted);
                in if length splitted == 1 then {
                  inherit version;
                  src = fetchTarball "https://github.com/math-comp/math-comp/archive/${version}.tar.gz";
                } else {
                  inherit version;
                  src = fetchTarball "https://github.com/${owner}/math-comp/archive/${ref}.tar.gz";
                };

          attrs =
            if overrides == null || overrides == "" then _: {}
            else  if isString overrides then string-attrs
            else  if isPath overrides then { version = baseNameOf overrides; src = overrides; }
            else  if isAttrs overrides then pkgUp old overrides
            else  let overridesStr = toString overrides; in
                  abort "${overridesStr} not a legitimate overrides";
      in
        attrs // (if attrs?version && ! (attrs?name)
                  then { name = "coq${coq.coq-version}-${pkgname}-${attrs.version}"; } else {});

  # generates {ssreflect = «derivation ...» ; ... ; character = «derivation ...», ...}
  mkMathcompGenSet = pkgs: o:
    fold (pkg: pkgs: pkgs // {${pkg} = mkMathcompGen pkg o;}) {} pkgs;
  # generates the derivation of one mathcomp package.
  mkMathcompGen = package: overrides:
    let
      up = x: o: x // (toOverrideFun o x);
      fixdeps = attrs:
        let version = attrs.version or "master";
            mcdeps  = if package == "single" then {}
                      else mkMathcompGenSet (filter isString attrs.passthru.mathcompDeps) overrides;
            allmc   = mkMathcompGenSet (mathcomp-config.packages version ++ [ "single" ]) overrides;
        in {
          propagatedBuildInputs = [ coq ]
                                  ++ filter isDerivation attrs.passthru.mathcompDeps
                                  ++ attrValues mcdeps
          ;
          passthru = allmc //
                     { overrideMathcomp = o: mathcomp_ (old: up (up old overrides) o); };
        };
    in
      stdenv.mkDerivation (up (up (default-attrs package) overrides) fixdeps);
in
{
  mathcomp-config    = mathcomp-config-initial;
  mathcomp_          = mkMathcompGen "all";
  mathcomp           = mathcomp_ mathcomp-config.preferred-version;
  # mathcomp-single    = mathcomp.single;
  ssreflect          = mathcomp.ssreflect;
  mathcomp-ssreflect = mathcomp.ssreflect;
  mathcomp-fingroup  = mathcomp.fingroup;
  mathcomp-algebra   = mathcomp.algebra;
  mathcomp-solvable  = mathcomp.solvable;
  mathcomp-field     = mathcomp.field;
  mathcomp-character = mathcomp.character;
}
