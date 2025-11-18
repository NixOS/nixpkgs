{
  coq,
  mkCoqDerivation,
  mathcomp,
  bignums,
  flocq,
  coquelicot,
  interval,
  mathcomp-reals-stdlib,
  multinomials,
  coqeal,
  lib,
  version ? null,
}:

let
  repo = "validsdp";
  owner = "validsdp";

  inherit version;
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
        (case (range "9.0" "9.1") (isGe "2.3.0") "1.1.1")
        (case (range "9.0" "9.1") (range "2.3.0" "2.4.0") "1.1.0")
      ]
      null;
  release = {
    "1.1.0".sha256 = "sha256-lbESAFBEBpOShNFh6RZQYPLRhdqYvdKBrxJOMy2L+Ws=";
    "1.1.1".sha256 = "sha256-B+Gy16WjBqqNHvjLE6nBV/ulfDVZUWwA5FO07XnqC60=";
  };
  releaseRev = v: "v${v}";

  # list of packages sorted by dependency order
  packages = {
    "libvalidsdp" = [ ];
    "validsdp" = [ "libvalidsdp" ];
  };

  validsdp_ =
    package:
    let
      libvalidsdp-deps = [
        mathcomp.field
        bignums
        flocq
        coquelicot
        interval
        mathcomp-reals-stdlib
      ];
      validsdp-deps = [
        mathcomp.field
        bignums
        flocq
        interval
        mathcomp-reals-stdlib
        multinomials
        coqeal
        coq.ocamlPackages.osdp
        coq.ocamlPackages.ocplib-simplex
      ];
      intra-deps = map validsdp_ packages.${package};
      pkgpath = lib.switch package [
        {
          case = "libvalidsdp";
          out = "libvalidsdp";
        }
        {
          case = "validsdp";
          out = ".";
        }
      ] package;
      pname = package;

      derivation = mkCoqDerivation {
        inherit
          version
          pname
          defaultVersion
          release
          releaseRev
          repo
          owner
          ;

        namePrefix = [
          "coq"
        ];

        mlPlugin = package == "validsdp";

        propagatedBuildInputs =
          intra-deps
          ++ lib.optionals (package == "libvalidsdp") libvalidsdp-deps
          ++ lib.optionals (package == "validsdp") validsdp-deps;

        preBuild = ''
          cd ${pkgpath}
        '';

        meta = {
          description = "ValidSDP";
          license = lib.licenses.lgpl21Plus;
        };

        passthru = lib.mapAttrs (package: deps: validsdp_ package) packages;
      };
    in
    derivation;
in
validsdp_ "validsdp"
