{ stdenv, fetchFromGitHub, coq, mathcomp, coqPackages,
  recurseIntoAttrs }:
with builtins // stdenv.lib;
let current-mathcomp = mathcomp; in
let
# configuring packages
param = {
  finmap = {
    version-sha256 = {
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
      "0.2.0" = "1186xjxgns4ns1szyi931964bjm0mp126qzlv10mkqqgfw07nhrd";
      "0.1.0" = "0hwkr2wzy710pcyh274fcarzdx8sv8myp16pv0vq5978nmih46al";
    };
    description = "Analysis library compatible with Mathematical Components";
  };
};
versions = {
  "1.8.0" = {
    finmap.version = "1.2.0";
    bigenough.version = "1.0.0";
    analysis = {
      version = "0.2.0";
      core-deps = with coqPackages; [ mathcomp_1_8-field ];
      extra-deps = with coqPackages; [ mathcomp_1_8-finmap mathcomp_1_8-bigenough ];
    };
    multinomials = {
      version = "1.2";
      core-deps = with coqPackages; [ mathcomp_1_8-algebra ];
      extra-deps = with coqPackages; [ mathcomp_1_8-finmap mathcomp_1_8-bigenough ];
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
  };
};

# generic package generator
packageGen = {
  # optional arguments
  src ? "",
  owner ? "math-comp",
  core-deps ? [ coqPackages.mathcomp-ssreflect ],
  extra-deps ? [],
  coq-versions ? ["8.6" "8.7" "8.8" "8.9"],
  mathcomp ? current-mathcomp,
  license ? mathcomp.meta.license,
  # mandatory
  package, version, version-sha256, description
  }:
  if version == "" then {}
  else { "${package}" =
  let from = src; in

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
    };

    passthru = {
      inherit version-sha256;
      compatibleCoqVersions = v: builtins.elem v coq-versions;
    };
  };};

current-versions = versions."${current-mathcomp.version}"
  or (throw "no mathcomp extra packages found for mathcomp ${current-mathcomp.version}");

select = x: mapAttrs (n: pkg: {package = n;} // pkg)
              (recursiveUpdate (overrideExisting x param) x);

all = (mapAttrs' (n: pkg:
        {name = "mathcomp_1_7-${n}";
         value = (packageGen ({mathcomp = coqPackages.mathcomp_1_7;} // pkg))."${n}";})
        (select versions."1.7.0")) //
      (mapAttrs' (n: pkg:
        {name = "mathcomp_1_8-${n}";
         value = (packageGen ({mathcomp = coqPackages.mathcomp_1_8;} // pkg))."${n}";})
        (select versions."1.8.0")) //
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
