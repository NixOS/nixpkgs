##########################################################
# Main derivation:                                       #
#   mathcomp-finmap mathcomp-analysis mathcomp-bigenough #
#   mathcomp-multinomials mathcomp-real-closed coqeal    #
# Additionally:                                          #
#   mathcomp-extra-all  contains all the extra packages  #
#   mathcomp-extra-fast contains the one not marked slow #
########################################################################
# This file mainly provides the above derivations, which are packages  #
# extra mathcomp libraries based on mathcomp.                          #
########################################################################

#####################################################
# Compiling customs versions using `mathcomp-extra` #
##############################################################################
# The prefered way to compile a custom version of mathcomp extra packages    #
# (other than released versions which should be added to                     #
# `mathcomp-extra-config-initial` and pushed to nixpkgs, see below),         #
# is to use `coqPackages.mathcomp-extra name version` where                  #
# 1. `name` is a string representing the name of a declared package          #
#    OR undeclared package.                                                  #
# 2. `version` is either:                                                    #
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
#                                                                            #
# Should you choose to use `pkg.overrideAttrs` instead, we provide the       #
# function mathcomp-extra-override which takes a name and a version exactly  #
# as above and returns an override function.                                 #
##############################################################################

#########################################################################
# Example of use: https://github.com/math-comp/math-comp/wiki/Using-nix #
#########################################################################

###########################################
# Adding a new package or package version #
################################################################################
# 1. Update or add a `pacakge` entry to `for-package`, it must be a function   #
#    taking the version as argument and returning an attribute set. Everything #
#    is optional and the default for the sources of the repository and the     #
#    homepage will be https://github.com/math-comp/${package}.                 #
#                                                                              #
# 2. Update or add a `package` entry to `sha256` for each release.             #
#    You may use                                                               #
#    ```sh                                                                     #
#    nix-prefetch-url --unpack                                                 #
#    https://github.com/math-comp/math-comp/archive/version.tar.gz             #
#    ```                                                                       #
#                                                                              #
# 3. Update or create a new consistent set of extra packages.                  #
#    /!\ They must all be co-compatible. /!\                                   #
#    Do not use versions that may disappear: it must either be                 #
#    - a tag from the main repository (e.g. version or tag), or                #
#    - a revision hash that has been *merged in master*                        #
################################################################################

{ stdenv, fetchFromGitHub, recurseIntoAttrs,
  which, mathcomp, coqPackages,
  mathcomp-extra-config, mathcomp-extra-override,
  mathcomp-extra, current-mathcomp-extra,
}:
with builtins // stdenv.lib;
let
  ##############################
  # CONFIGURATION, please edit #
  ##############################
  ############################
  # Packages base delaration #
  ############################
  mathcomp-extra-config-initial = {
    for-package = {
      finmap = version: {
        description = "A finset and finmap library";
        homepage = "https://github.com/math-comp/finmap";
        compatibleCoqVersions = flip elem [ "8.8" "8.9" "8.10" "8.11" ];
      };

      bigenough = version: {
        description = "A small library to do epsilon - N reasonning";
        homepage = "https://github.com/math-comp/bigenough";
        compatibleCoqVersions = flip elem [ "8.7" "8.8" "8.9" "8.10" "8.11" ];
      };

      multinomials = version: {
        description = "A Coq/SSReflect Library for Monoidal Rings and Multinomials";
        homepage = "https://github.com/math-comp/multinomials";
        buildInputs = [ which ];
        propagatedBuildInputs = with coqPackages;
          [ mathcomp.algebra mathcomp-finmap mathcomp-bigenough ];
        compatibleCoqVersions = flip elem [ "8.9" "8.10" "8.11" ];
      };

      analysis = version: {
        description = "Analysis library compatible with Mathematical Components";
        homepage = "https://github.com/math-comp/analysis";
        license = stdenv.lib.licenses.cecill-c;
        propagatedBuildInputs = with coqPackages;
          [ mathcomp.field mathcomp-finmap mathcomp-bigenough ];
        compatibleCoqVersions = flip elem ["8.8" "8.9" "8.10" "8.11" ];
      };

      real-closed = version: {
        description = "Mathematical Components Library on real closed fields";
        homepage = "https://github.com/math-comp/real-closed";
        propagatedBuildInputs = with coqPackages; [ coq mathcomp.field  mathcomp-bigenough ];
        compatibleCoqVersions = flip elem ["8.8" "8.9" "8.10" "8.11" ];
      };

      coqeal = version: {
        description = "CoqEAL - The Coq Effective Algebra Library";
        homepage = "https://github.com/coqeal/coqeal";
        license = stdenv.lib.licenses.mit;
        owner = "CoqEAL";
        buildInputs = [ which ];
        propagatedBuildInputs = with coqPackages;
          [ mathcomp-algebra bignums paramcoq mathcomp-multinomials ];
        compatibleCoqVersions = flip elem [ "8.9" "8.10" "8.11" ];
      };
    };

    ###############################
    # sha256 of released versions #
    ###############################
    sha256 = {
      finmap = {
        "1.5.0" = "0vx9n1fi23592b3hv5p5ycy7mxc8qh1y5q05aksfwbzkk5zjkwnq";
        "1.4.1" = "0kx4nx24dml1igk0w0qijmw221r5bgxhwhl5qicnxp7ab3c35s8p";
        "1.4.0" = "0mp82mcmrs424ff1vj3cvd8353r9vcap027h3p0iprr1vkkwjbzd";
        "1.3.4" = "0f5a62ljhixy5d7gsnwd66gf054l26k3m79fb8nz40i2mgp6l9ii";
        "1.3.3" = "1n844zjhv354kp4g4pfbajix0plqh7yxv6471sgyb46885298am5";
        "1.3.1" = "14rvm0rm5hd3pd0srgak3jqmddzfv6n7gdpjwhady5xcgrc7gsx7";
        "1.2.1" = "0jryb5dq8js3imbmwrxignlk5zh8gwfb1wr4b1s7jbwz410vp7zf";
        "1.2.0" = "0b6wrdr0d7rcnv86s37zm80540jl2wmiyf39ih7mw3dlwli2cyj4";
        "1.1.0" = "05df59v3na8jhpsfp7hq3niam6asgcaipg2wngnzxzqnl86srp2a";
        "1.0.0" = "0sah7k9qm8sw17cgd02f0x84hki8vj8kdz7h15i7rmz08rj0whpa";
      };
      bigenough = {
        "1.0.0" = "10g0gp3hk7wri7lijkrqna263346wwf6a3hbd4qr9gn8hmsx70wg";
      };
      analysis = {
        "0.2.3" = "0p9mr8g1qma6h10qf7014dv98ln90dfkwn76ynagpww7qap8s966";
        "0.2.2" = "1d5dwg9di2ppdzfg21zr0a691zigb5kz0lcw263jpyli1nrq7cvk";
        "0.2.0" = "1186xjxgns4ns1szyi931964bjm0mp126qzlv10mkqqgfw07nhrd";
        "0.1.0" = "0hwkr2wzy710pcyh274fcarzdx8sv8myp16pv0vq5978nmih46al";
      };
      multinomials = {
        "1.5.1" = "13nlfm2wqripaq671gakz5mn4r0xwm0646araxv0nh455p9ndjs3";
        "1.5"   = "064rvc0x5g7y1a0nip6ic91vzmq52alf6in2bc2dmss6dmzv90hw";
        "1.4"   = "0vnkirs8iqsv8s59yx1fvg1nkwnzydl42z3scya1xp1b48qkgn0p";
        "1.3"   = "0l3vi5n094nx3qmy66hsv867fnqm196r8v605kpk24gl0aa57wh4";
        "1.2"   = "1mh1w339dslgv4f810xr1b8v2w7rpx6fgk9pz96q0fyq49fw2xcq";
        "1.1"   = "1q8alsm89wkc0lhcvxlyn0pd8rbl2nnxg81zyrabpz610qqjqc3s";
        "1.0"   = "1qmbxp1h81cy3imh627pznmng0kvv37k4hrwi2faa101s6bcx55m";
      };
      real-closed = {
        "1.0.5" = "0q8nkxr9fba4naylr5xk7hfxsqzq2pvwlg1j0xxlhlgr3fmlavg2";
        "1.0.4" = "058v9dj973h9kfhqmvcy9a6xhhxzljr90cf99hdfcdx68fi2ha1b";
        "1.0.3" = "1xbzkzqgw5p42dx1liy6wy8lzdk39zwd6j14fwvv5735k660z7yb";
        "1.0.2" = "0097pafwlmzd0gyfs31bxpi1ih04i72nxhn99r93aj20mn7mcsgl";
        "1.0.1" = "0j81gkjbza5vg89v4n9z598mfdbql416963rj4b8fzm7dp2r4rxg";
      };
      coqeal = {
        "1.0.3" = "0hc63ny7phzbihy8l7wxjvn3haxx8jfnhi91iw8hkq8n29i23v24";
        "1.0.2" = "1brmf3gj03iky1bcl3g9vx8vknny7xfvs0y2rfr85am0296sxsfj";
        "1.0.1" = "19jhdrv2yp9ww0h8q73ihb2w1z3glz4waf2d2n45klafxckxi7bm";
        "1.0.0" = "1had6f1n85lmh9x31avbmgl3m0rsiw9f8ma95qzk5b57fjg5k1ii";
      };
    };

    ################################
    # CONSISTENT sets of packages. #
    ################################
    for-coq-and-mc = let
      v5 = {
        finmap.version       = "1.5.0";
        bigenough.version    = "1.0.0";
        analysis.version     = "678d3cc37f5f3c71b1bd550836eb44e3ba2a5459";
        multinomials.version = "1.5.1";
        real-closed.version  = "1.0.5";
        coqeal.version       = "CohenCyril/bdfc96771644b082e41268edc43d61dc5fda2358";
      };
      v4 = v3 // { coqeal.version = "1.0.3"; };
      v3 = {
        finmap.version       = "1.4.0";
        bigenough.version    = "1.0.0";
        analysis.version     = "0.2.3";
        multinomials.version = "1.5";
        real-closed.version  = "1.0.4";
        coqeal.version       = "1.0.0";
      };
      v2 = {
        finmap.version       = "1.3.4";
        bigenough.version    = "1.0.0";
        analysis.version     = "0.2.3";
        multinomials.version = "1.4";
        real-closed.version  = "1.0.3";
        coqeal.version       = "1.0.0";
      };
      v1 = {
        finmap.version       = "1.1.0";
        bigenough.version    = "1.0.0";
        multinomials.version = "1.1";
        real-closed.version  = "1.0.1";
        coqeal.version       = "1.0.0";
      };
    in
      {
        "8.11.1" = {
          "1.11.0+beta1" = v5;
          "1.10.0"       = v4;
        };
        "8.10.2" = {
          "1.11.0+beta1" = v5;
          "1.10.0"       = v4;
          "1.9.0"        = removeAttrs v3 ["coqeal"];
        };
        "8.9.1" = {
          "1.11.0+beta1" = removeAttrs v5 ["analysis"];
          "1.10.0"       = v4;
          "1.9.0"        = removeAttrs v3 ["coqeal"];
          "1.8.0"        = removeAttrs v2 ["coqeal"];
        };
        "8.8.2" = {
          "1.11.0+beta1" = removeAttrs v5 ["analysis"];
          "1.10.0"       = removeAttrs v4 ["analysis"];
          "1.9.0"        = removeAttrs v3 ["coqeal"];
          "1.8.0"        = removeAttrs v2 ["coqeal"];
          "1.7.0"        = removeAttrs v1 ["coqeal" "multinomials"];
        };
        "8.7.2" = {
          "1.11.0+beta1" = removeAttrs v5 ["analysis"];
          "1.10.0"       = removeAttrs v4 ["analysis"];
          "1.9.0"        = removeAttrs v3 ["coqeal"];
          "1.8.0"        = removeAttrs v2 ["coqeal"];
          "1.7.0"        = removeAttrs v1 ["coqeal" "multinomials"];
        };
      };
  };

  ##############################
  # GENERATION, EDIT WITH CARE #
  ##############################
  coq = coqPackages.coq;

  # update attributes using the configuration in the style of
  # the above for-package. Initiatize using `update-attrs pkgconfig {}`
  update-attrs = pkgcfg: old: rec {
    version = pkgcfg.version or old.version or "master";
    name = "coq${coq.coq-version}mathcomp${mathcomp.version}-${pkgcfg.name or "anonymous"}-${pkgcfg.version}";

    src = pkgcfg.src or old.src
          or (fetchTarball "${meta.homepage}/archive/${pkgcfg.version}.tar.gz");

    buildInputs = pkgcfg.buildInputs or old.buildInputs or [];

    propagatedBuildInputs =
      pkgcfg.propagatedBuildInputs or old.propagatedBuildInputs
        or (with coqPackages; [ ssreflect ]);

    installFlags = pkgcfg.installFlags or old.installFlags
                   or [ "-f" "Makefile.coq" "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

    meta = {
      platforms   = pkgcfg.platforms or old.platforms or mathcomp.meta.platforms;
      description = pkgcfg.description or old.description or "No description provided";
      license     = pkgcfg.license or old.license or mathcomp.meta.license;
      homepage    = pkgcfg.homepage or old.homepage or src.meta.homepage
                    or "https://github.com/math-comp/${pkgcfg}";
      maintainers = [ maintainers.vbgl maintainers.cohencyril ];
      owner = pkgcfg.owner or old.owner or "math-comp";
    };

    passthru = {
      compatibleCoqVersions = pkgcfg.compatibleCoqVersions
                              or old.compatibleCoqVersions
                              or (_: true);
    };
  };

  # uses `mathcomp-extra-config.for-package` to get a configuration
  getcfg = name: version:
    {inherit name version;} //
    ((mathcomp-extra-config.for-package.${name} or (version: {})) version);

  # converts a string, path or attribute set into an override function
  mathcomp-extra-override-initial = package: overrides:
    if isFunction overrides then overrides else old:
      let old-owner = old.meta.owner or "math-comp"; in
      if overrides == null || overrides == "" then _: {}
      else  if overrides == "broken" then {
        meta.broken = true;
        passthru.compatibleCoqVersions = _: false;
      }
      else  if isString overrides then
        if mathcomp-extra-config.sha256?${package} &&
           mathcomp-extra-config.sha256.${package}?${overrides} then
             let
               version = overrides;
               config = getcfg package version;
               default-owner = config.owner or old-owner;
             in
             update-attrs (getcfg package version // (rec {
               src = fetchFromGitHub {
                 owner  = default-owner;
                 repo   = package;
                 rev    = version;
                 sha256 = mathcomp-extra-config.sha256.${package}.${version};
               };
             })) old
        else
          let splitted = filter isString (split "/" overrides);
              owner = head splitted;
              ref = concatStringsSep "/" (tail splitted);
              version = head (reverseList splitted);
              config = getcfg package version;
              default-owner = config.owner or old-owner;
          in
            update-attrs (config // {
              src = fetchTarball ("https://github.com/" +
                    (if length splitted == 1
                     then "${default-owner}/${package}/archive/${version}.tar.gz"
                     else "${owner}/${package}/archive/${ref}.tar.gz"));
            }) old
      else  if isPath overrides then update-attrs
        (getcfg package (baseNameOf overrides) // { src = overrides; }) old
      else  if isAttrs overrides then update-attrs
        (getcfg package (overrides.version or old.version or "master") // overrides) old
      else  let overridesStr = toString overrides; in
            abort "${overridesStr} not a legitimate overrides";

  # applies mathcomp-extra-config.for-coq-and-mc to the current mathcomp version
  for-this = mathcomp-extra-config.for-coq-and-mc.${coq.version}.${mathcomp.version} or {};

  # specializes mathcomp-extra to the current mathcomp version.
  current-mathcomp-extra-intial = name:
    (mathcomp-extra name (for-this.${name}.version or "broken")).overrideAttrs
      (for-this.${name}.overrides or (_: {}));
in
  {
    mathcomp-extra-override = mathcomp-extra-override-initial;
    mathcomp-extra-config   = mathcomp-extra-config-initial;
    current-mathcomp-extra  = current-mathcomp-extra-intial;
    mathcomp-extra          = package: version:
      stdenv.mkDerivation (mathcomp-extra-override package version {});

    mathcomp-finmap       = current-mathcomp-extra "finmap";
    mathcomp-analysis     = current-mathcomp-extra "analysis";
    mathcomp-bigenough    = current-mathcomp-extra "bigenough";
    mathcomp-multinomials = current-mathcomp-extra "multinomials";
    mathcomp-real-closed  = current-mathcomp-extra "real-closed";
    coqeal                = current-mathcomp-extra "coqeal";

    mathcomp-extra-fast    = map (pkg: current-mathcomp-extra pkg)
      (attrNames (filterAttrs (pkg: config: !(config?slow && config.slow)) for-this));
    mathcomp-extra-all    = map (pkg: current-mathcomp-extra pkg) (attrNames for-this);
  }
