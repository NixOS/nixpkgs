{ stdenv, fetchFromGitHub, coq, mathcomp, coqPackages,
  recurseIntoAttrs }:
with builtins // stdenv.lib;
let current-mathcomp = mathcomp; in
let
# configuring packages
param = {
  finmap = {
    version-sha256 = {
      "1.2.1" = "0jryb5dq8js3imbmwrxignlk5zh8gwfb1wr4b1s7jbwz410vp7zf";
      "1.2.0" = "0b6wrdr0d7rcnv86s37zm80540jl2wmiyf39ih7mw3dlwli2cyj4";
      "1.1.0" = "05df59v3na8jhpsfp7hq3niam6asgcaipg2wngnzxzqnl86srp2a";
      "1.0.0" = "0sah7k9qm8sw17cgd02f0x84hki8vj8kdz7h15i7rmz08rj0whpa";
    };
    description = "A finset and finmap library";
  };
  bigenough = {
    version-sha256 = {"1.0.0" = "10g0gp3hk7wri7lijkrqna263346wwf6a3hbd4qr9gn8hmsx70wg";};
    description = "A small library to do epsilon - N reasonning";
  };
  multinomials = {
    version-sha256 = {
      "1.2" = "1mh1w339dslgv4f810xr1b8v2w7rpx6fgk9pz96q0fyq49fw2xcq";
      "1.1" = "1q8alsm89wkc0lhcvxlyn0pd8rbl2nnxg81zyrabpz610qqjqc3s";
      "1.0" = "1qmbxp1h81cy3imh627pznmng0kvv37k4hrwi2faa101s6bcx55m";
    };
    description = "A Coq/SSReflect Library for Monoidal Rings and Multinomials";
  };
 analysis = {
    version-sha256 = {
      "0.2.2" = "1d5dwg9di2ppdzfg21zr0a691zigb5kz0lcw263jpyli1nrq7cvk";
      "0.2.0" = "1186xjxgns4ns1szyi931964bjm0mp126qzlv10mkqqgfw07nhrd";
      "0.1.0" = "0hwkr2wzy710pcyh274fcarzdx8sv8myp16pv0vq5978nmih46al";
    };
    description = "Analysis library compatible with Mathematical Components";
  };
  real-closed = {
    version-sha256 = {
      "1.0.3" = "1xbzkzqgw5p42dx1liy6wy8lzdk39zwd6j14fwvv5735k660z7yb";
      "1.0.2" = "0097pafwlmzd0gyfs31bxpi1ih04i72nxhn99r93aj20mn7mcsgl";
      "1.0.1" = "0j81gkjbza5vg89v4n9z598mfdbql416963rj4b8fzm7dp2r4rxg";
    };
    description = "Mathematical Components Library on real closed fields";
  };
};
versions = {
  "1.9.0" = {
    finmap.version = "1.2.1";
    bigenough.version = "1.0.0";
    analysis = {
      version = "0.2.2";
      core-deps = with coqPackages; [ mathcomp_1_9-field ];
      extra-deps = with coqPackages; [ mathcomp_1_9-finmap mathcomp_1_9-bigenough ];
    };
    multinomials = {};
    real-closed = {
      version = "1.0.3";
      core-deps = with coqPackages; [ mathcomp_1_9-field ];
      extra-deps = with coqPackages; [ mathcomp_1_9-bigenough ];
    };
  }; 
  "1.8.0" = {
    finmap.version = "1.2.1";
    bigenough.version = "1.0.0";
    analysis = {
      version = "0.2.2";
      core-deps = with coqPackages; [ mathcomp_1_8-field ];
      extra-deps = with coqPackages; [ mathcomp_1_8-finmap mathcomp_1_8-bigenough ];
    };
    multinomials = {
      version = "1.2";
      core-deps = with coqPackages; [ mathcomp_1_8-algebra ];
      extra-deps = with coqPackages; [ mathcomp_1_8-finmap mathcomp_1_8-bigenough ];
    };
    real-closed = {
      version = "1.0.3";
      core-deps = with coqPackages; [ mathcomp_1_8-field ];
      extra-deps = with coqPackages; [ mathcomp_1_8-bigenough ];
    };
  };
  "1.7.0" = {
    finmap.version = "1.1.0";
    bigenough.version = "1.0.0";
    analysis = {
      version = "0.1.0";
      core-deps = with coqPackages; [ mathcomp_1_7-field ];
      extra-deps = with coqPackages; [ mathcomp_1_7-finmap mathcomp_1_7-bigenough ];
    };
    multinomials = {
      version = "1.1";
      core-deps = with coqPackages; [ mathcomp_1_7-algebra ];
      extra-deps = with coqPackages; [ mathcomp_1_7-finmap_1_0 mathcomp_1_7-bigenough ];
    };
    real-closed = {
      version = "1.0.1";
      core-deps = with coqPackages; [ mathcomp_1_8-field ];
      extra-deps = with coqPackages; [ mathcomp_1_8-bigenough ];
    };
  };
};

# generic package generator
packageGen = {
  # optional arguments
  src ? "",
  owner ? "math-comp",
  core-deps ? [ coqPackages.mathcomp-ssreflect ],
  extra-deps ? [],
  mathcomp ? current-mathcomp,
  compatibleCoqVersions ? null,
  license ? mathcomp.meta.license,
  # mandatory
  package, version ? "broken", version-sha256, description
  }:
  let
    theCompatibleCoqVersions = if compatibleCoqVersions == null
                               then mathcomp.compatibleCoqVersions
                               else compatibleCoqVersions;
  in
  { "${package}" = let from = src; in

  stdenv.mkDerivation rec {
    inherit version;
    name = "coq${coq.coq-version}-mathcomp-${mathcomp.version}-${package}-${version}";

    src = if from == "" then fetchFromGitHub {
      owner = owner;
      repo = package;
      rev = version;
      sha256 = version-sha256."${version}";
    } else from;

    propagatedBuildInputs = [ coq mathcomp ] ++ extra-deps;

    installFlags = "-f Makefile.coq COQLIB=$(out)/lib/coq/${coq.coq-version}/";

    meta = {
      inherit description;
      inherit license;
      inherit (src.meta) homepage;
      inherit (mathcomp.meta) platforms;
      maintainers = [ stdenv.lib.maintainers.vbgl ];
      broken = (version == "broken");
    };

    passthru = {
      inherit version-sha256;
      compatibleCoqVersions = if meta.broken then _: false
                              else theCompatibleCoqVersions;
    };
  };
  };

current-versions = versions."${current-mathcomp.version}" or {};

select = x: mapAttrs (n: pkg: {package = n;} // pkg) (recursiveUpdate param x);

for-version = v: suffix: (mapAttrs' (n: pkg:
        {name = "mathcomp_${suffix}-${n}";
         value = (packageGen ({
             mathcomp = coqPackages."mathcomp_${suffix}";
           } // pkg))."${n}";})
        (select versions."${v}"));

all = (for-version "1.7.0" "1_7") //
      (for-version "1.8.0" "1_8") //
      (for-version "1.9.0" "1_9") //
     (recurseIntoAttrs (mapDerivationAttrset dontDistribute (
        mapAttrs' (n: pkg: {name = "mathcomp-${n}"; value = (packageGen pkg)."${n}";})
              (select current-versions))));
in
{
mathcompExtraGen = packageGen;
mathcomp_1_7-finmap_1_0 =
  (packageGen (select {finmap = {version = "1.0.0";
                                 mathcomp = coqPackages.mathcomp_1_7;};
                      }).finmap).finmap;
multinomials = all.mathcomp-multinomials;
} // all
