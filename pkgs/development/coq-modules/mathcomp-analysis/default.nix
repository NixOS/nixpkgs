{
  lib,
  mkCoqDerivation,
  mathcomp,
  mathcomp-finmap,
  mathcomp-bigenough,
  hierarchy-builder,
  stdlib,
  single ? false,
  coqPackages,
  coq,
  version ? null,
}@args:

let
  repo = "analysis";
  owner = "math-comp";

  release."1.12.0".sha256 = "sha256-PF10NlZ+aqP3PX7+UsZwgJT9PEaDwzvrS/ZGzjP64Wo=";
  release."1.11.0".sha256 = "sha256-1apbzBvaLNw/8ARLUhGGy89CyXW+/6O4ckdxKPraiVc=";
  release."1.9.0".sha256 = "sha256-zj7WSDUg8ISWxcipGpjEwvvnLp1g8nm23BZiib/15+g=";
  release."1.8.0".sha256 = "sha256-2ZafDmZAwGB7sxdUwNIE3xvwBRw1kFDk0m5Vz+onWZc=";
  release."1.7.0".sha256 = "sha256-GgsMIHqLkWsPm2VyOPeZdOulkN00IoBz++qA6yE9raQ=";
  release."1.5.0".sha256 = "sha256-EWogrkr5TC5F9HjQJwO3bl4P8mij8U7thUGJNNI+k88=";
  release."1.4.0".sha256 = "sha256-eDggeuEU0fMK7D5FbxvLkbAgpLw5lwL/Rl0eLXAnJeg=";
  release."1.2.0".sha256 = "sha256-w6BivDM4dF4Iv4rUTy++2feweNtMAJxgGExPfYGhXxo=";
  release."1.1.0".sha256 = "sha256-wl4kZf4mh9zbFfGcqaFEgWRyp0Bj511F505mYodpS6o=";
  release."1.0.0".sha256 = "sha256-KiXyaWB4zQ3NuXadq4BSWfoN1cIo1xiLVSN6nW03tC4=";
  release."0.7.0".sha256 = "sha256-JwkyetXrFsFHqz8KY3QBpHsrkhmEFnrCGuKztcoen60=";
  release."0.6.7".sha256 = "sha256-3i2PBMEwihwgwUmnS0cmrZ8s+aLPFVq/vo0aXMUaUyA=";
  release."0.6.6".sha256 = "sha256-tWtv6yeB5/vzwpKZINK9OQ0yQsvD8qu9zVSNHvLMX5Y=";
  release."0.6.5".sha256 = "sha256-oJk9/Jl1SWra2aFAXRAVfX7ZUaDfajqdDksYaW8dv8E=";
  release."0.6.1".sha256 = "sha256-1VyNXu11/pDMuH4DmFYSUF/qZ4Bo+/Zl3Y0JkyrH/r0=";
  release."0.6.0".sha256 = "sha256-0msICcIrK6jbOSiBu0gIVU3RHwoEEvB88CMQqW/06rg=";
  release."0.5.3".sha256 = "sha256-1NjFsi5TITF8ZWx1NyppRmi8g6YaoUtTdS9bU/sUe5k=";
  release."0.5.2".sha256 = "0yx5p9zyl8jv1vg7rgkyq8dqzkdnkqv969mi62whmhkvxbavgzbw";
  release."0.5.1".sha256 = "1hnzqb1gxf88wgj2n1b0f2xm6sxg9j0735zdsv6j12hlvx5lwk68";
  release."0.3.13".sha256 = "sha256-Yaztew79KWRC933kGFOAUIIoqukaZOdNOdw4XszR1Hg=";
  release."0.3.10".sha256 = "sha256-FBH2c8QRibq5Ycw/ieB8mZl0fDiPrYdIzZ6W/A3pIhI=";
  release."0.3.9".sha256 = "sha256-uUU9diBwUqBrNRLiDc0kz0CGkwTZCUmigPwLbpDOeg4=";
  release."0.3.6".sha256 = "0g2j7b2hca4byz62ssgg90bkbc8wwp7xkb2d3225bbvihi92b4c5";
  release."0.3.4".sha256 = "18mgycjgg829dbr7ps77z6lcj03h3dchjbj5iir0pybxby7gd45c";
  release."0.3.3".sha256 = "1m2mxcngj368vbdb8mlr91hsygl430spl7lgyn9qmn3jykack867";
  release."0.3.1".sha256 = "1iad288yvrjv8ahl9v18vfblgqb1l5z6ax644w49w9hwxs93f2k8";
  release."0.2.3".sha256 = "0p9mr8g1qma6h10qf7014dv98ln90dfkwn76ynagpww7qap8s966";

  defaultVersion =
    let
      case = coq: mc: out: {
        cases = [
          coq
          mc
        ];
        inherit out;
      };
    in
    with lib.versions;
    lib.switch
      [ coq.coq-version mathcomp.version ]
      [
        (case (range "8.20" "9.1") (range "2.1.0" "2.4.0") "1.12.0")
        (case (range "8.19" "8.20") (range "2.1.0" "2.3.0") "1.9.0")
        (case (range "8.17" "8.20") (range "2.0.0" "2.2.0") "1.1.0")
        (case (range "8.17" "8.19") (range "1.17.0" "1.19.0") "0.7.0")
        (case (range "8.17" "8.18") (range "1.15.0" "1.18.0") "0.6.7")
        (case (range "8.17" "8.18") (range "1.15.0" "1.18.0") "0.6.6")
        (case (range "8.14" "8.18") (range "1.15.0" "1.17.0") "0.6.5")
        (case (range "8.14" "8.18") (range "1.13.0" "1.16.0") "0.6.1")
        (case (range "8.14" "8.18") (range "1.13" "1.15") "0.5.2")
        (case (range "8.13" "8.15") (range "1.13" "1.14") "0.5.1")
        (case (range "8.13" "8.15") (range "1.12" "1.14") "0.3.13")
        (case (range "8.11" "8.14") (range "1.12" "1.13") "0.3.10")
        (case (range "8.10" "8.12") "1.11.0" "0.3.3")
        (case (range "8.10" "8.11") "1.11.0" "0.3.1")
        (case (range "8.8" "8.11") (range "1.8" "1.10") "0.2.3")
      ]
      null;

  # list of analysis packages sorted by dependency order
  packages = {
    "classical" = [ ];
    "reals" = [ "classical" ];
    "experimental-reals" = [ "reals" ];
    "analysis" = [ "reals" ];
    "reals-stdlib" = [ "reals" ];
    "analysis-stdlib" = [
      "analysis"
      "reals-stdlib"
    ];
  };

  mathcomp_ =
    package:
    let
      classical-deps = [
        mathcomp.ssreflect
        mathcomp.algebra
        mathcomp-finmap
      ];
      experimental-reals-deps = [ mathcomp-bigenough ];
      analysis-deps = [
        mathcomp.field
        mathcomp-bigenough
      ];
      intra-deps = lib.optionals (package != "single") (map mathcomp_ packages.${package});
      pkgpath = lib.switch package [
        {
          case = "single";
          out = ".";
        }
        {
          case = "analysis";
          out = "theories";
        }
        {
          case = "experimental-reals";
          out = "experimental_reals";
        }
        {
          case = "reals-stdlib";
          out = "reals_stdlib";
        }
        {
          case = "analysis-stdlib";
          out = "analysis_stdlib";
        }
      ] package;
      pname = if package == "single" then "mathcomp-analysis-single" else "mathcomp-${package}";
      derivation = mkCoqDerivation ({
        inherit
          version
          pname
          defaultVersion
          release
          repo
          owner
          ;

        namePrefix = [
          "coq"
          "mathcomp"
        ];

        propagatedBuildInputs =
          intra-deps
          ++ lib.optionals (lib.elem package [
            "classical"
            "single"
          ]) classical-deps
          ++ lib.optionals (lib.elem package [
            "experimental-reals"
            "single"
          ]) experimental-reals-deps
          ++ lib.optionals (lib.elem package [
            "analysis"
            "single"
          ]) analysis-deps
          ++ lib.optional (lib.elem package [
            "reals-stdlib"
            "analysis-stdlib"
            "single"
          ]) stdlib;

        preBuild = ''
          cd ${pkgpath}
        '';

        meta = {
          description = "Analysis library compatible with Mathematical Components";
          maintainers = [ lib.maintainers.cohencyril ];
          license = lib.licenses.cecill-c;
        };

        passthru = lib.mapAttrs (package: deps: mathcomp_ package) packages;
      });
      # split packages didn't exist before 0.6, so building nothing in that case
      patched-derivation1 = derivation.overrideAttrs (
        o:
        lib.optionalAttrs
          (
            o.pname != null
            && o.pname != "mathcomp-analysis"
            && o.version != null
            && o.version != "dev"
            && lib.versions.isLt "0.6" o.version
          )
          {
            preBuild = "";
            buildPhase = "echo doing nothing";
            installPhase = "echo doing nothing";
          }
      );
      patched-derivation2 = patched-derivation1.overrideAttrs (
        o:
        lib.optionalAttrs (
          o.pname != null
          && o.pname == "mathcomp-analysis"
          && o.version != null
          && o.version != "dev"
          && lib.versions.isLt "0.6" o.version
        ) { preBuild = ""; }
      );
      # only packages classical and analysis existed before 1.7, so building nothing in that case
      patched-derivation3 = patched-derivation2.overrideAttrs (
        o:
        lib.optionalAttrs
          (
            o.pname != null
            && o.pname != "mathcomp-classical"
            && o.pname != "mathcomp-analysis"
            && o.version != null
            && o.version != "dev"
            && lib.versions.isLt "1.7" o.version
          )
          {
            preBuild = "";
            buildPhase = "echo doing nothing";
            installPhase = "echo doing nothing";
          }
      );
      patched-derivation = patched-derivation3.overrideAttrs (
        o:
        lib.optionalAttrs (o.version != null && (o.version == "dev" || lib.versions.isGe "0.3.4" o.version))
          {
            propagatedBuildInputs = o.propagatedBuildInputs ++ [ hierarchy-builder ];
          }
      );
    in
    patched-derivation;
in
mathcomp_ (if single then "single" else "analysis")
