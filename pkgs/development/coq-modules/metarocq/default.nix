{
  lib,
  mkCoqDerivation,
  single ? false,
  coq,
  equations,
  version ? null,
}@args:

let
  repo = "metarocq";
  owner = "MetaRocq";
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    lib.switch coq.coq-version [
      (case ("9.0") "1.4-9.0")
    ] null;
  release = {
    "1.4-9.0".sha256 = "sha256-5QecDAMkvgfDPZ7/jDfnOgcE+Eb1LTAozP7nz6nkuxg=";
  };
  releaseRev = v: "v${v}";

  # list of core metarocq packages and their dependencies
  packages = {
    "utils" = [ ];
    "common" = [ "utils" ];
    "template-rocq" = [ "common" ];
    "pcuic" = [ "common" ];
    "safechecker" = [ "pcuic" ];
    "template-pcuic" = [
      "template-rocq"
      "pcuic"
    ];
    "erasure" = [
      "safechecker"
      "template-pcuic"
    ];
    "quotation" = [
      "template-rocq"
      "pcuic"
      "template-pcuic"
    ];
    "safechecker-plugin" = [
      "template-pcuic"
      "safechecker"
    ];
    "erasure-plugin" = [
      "template-pcuic"
      "erasure"
    ];
    "translations" = [ "template-rocq" ];
    "all" = [
      "safechecker-plugin"
      "erasure-plugin"
      "translations"
      "quotation"
    ];
  };

  template-rocq = metarocq_ "template-rocq";

  metarocq_ =
    package:
    let
      metarocq-deps = lib.optionals (package != "single") (map metarocq_ packages.${package});
      pkgpath = if package == "single" then "./" else "./${package}";
      pname = if package == "all" then "metarocq" else "metarocq-${package}";
      pkgallMake = ''
        mkdir all
        echo "all:" > all/Makefile
        echo "install:" >> all/Makefile
      '';
      derivation = mkCoqDerivation (
        {
          inherit
            version
            pname
            defaultVersion
            release
            releaseRev
            repo
            owner
            ;

          mlPlugin = true;
          propagatedBuildInputs = [
            equations
            coq.ocamlPackages.zarith
            coq.ocamlPackages.stdlib-shims
          ]
          ++ metarocq-deps;

          patchPhase = ''
            patchShebangs ./configure.sh
            patchShebangs ./template-rocq/update_plugin.sh
            patchShebangs ./template-rocq/gen-src/to-lower.sh
            patchShebangs ./safechecker-plugin/clean_extraction.sh
            patchShebangs ./erasure-plugin/clean_extraction.sh
            echo "CAMLFLAGS+=-w -60 # Unused module" >> ./safechecker/Makefile.plugin.local
            sed -i -e 's/mv $i $newi;/mv $i tmp; mv tmp $newi;/' ./template-rocq/gen-src/to-lower.sh ./safechecker-plugin/clean_extraction.sh ./erasure-plugin/clean_extraction.sh
          '';

          configurePhase =
            lib.optionalString (package == "all") pkgallMake
            + ''
              touch ${pkgpath}/metarocq-config
            ''
            +
              lib.optionalString
                (lib.elem package [
                  "erasure"
                  "template-pcuic"
                  "quotation"
                  "safechecker-plugin"
                  "erasure-plugin"
                  "translations"
                ])
                ''
                  echo  "-I ${template-rocq}/lib/coq/${coq.coq-version}/user-contrib/MetaRocq/Template/" > ${pkgpath}/metarocq-config
                ''
            + lib.optionalString (package == "single") ''
              ./configure.sh local
            '';

          preBuild = ''
            cd ${pkgpath}
          '';

          meta = {
            homepage = "https://metarocq.github.io/";
            license = lib.licenses.mit;
            maintainers = with lib.maintainers; [ cohencyril ];
          };
        }
        // lib.optionalAttrs (package != "single") {
          passthru = lib.mapAttrs (package: deps: metarocq_ package) packages;
        }
      );
    in
    derivation;
in
metarocq_ (if single then "single" else "all")
