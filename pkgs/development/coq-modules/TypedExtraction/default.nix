{
  lib,
  mkCoqDerivation,
  which,
  coq,
  stdlib,
  metarocq,
  version ? null,
  single ? false,
}:

let
  pname = "TypedExtraction";
  repo = "rocq-typed-extraction";
  owner = "peregrine-project";
  domain = "github.com";

  inherit version;
  defaultVersion =
    let
      case = coq: mr: out: {
        cases = [
          coq
          mr
        ];
        inherit out;
      };
    in
    lib.switch
      [
        coq.coq-version
        metarocq.version
      ]
      [
        (case "9.1" (lib.versions.range "1.4" "1.4.1") "0.2.0")
      ]
      null;
  release = {
    "0.2.0".sha256 = "sha256-rgg39X45IXjcnejBhh8N7wMiH+gHQrfO8pBbFEWOGVI=";
  };
  releaseRev = v: "v${v}";

  packages = {
    "common" = [ ];
    "elm" = [
      "common"
    ];
    "rust" = [
      "common"
    ];
    "plugin" = [
      "elm"
      "rust"
    ];
    "all" = [
      "plugin"
    ];
  };

  typedextraction_ =
    package:
    let
      typedextraction-deps = lib.optionals (package != "single") (
        map typedextraction_ packages.${package}
      );
      pkgpath = if package == "single" then "./" else "./${package}";
      pname = if package == "all" then "TypedExtraction" else "TypedExtraction-${package}";
      pkgallMake = ''
        mkdir all
        echo "all:" > all/Makefile
        echo "install:" >> all/Makefile
      '';
      derivation = (
        mkCoqDerivation (
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
              stdlib
              coq.ocamlPackages.findlib
              metarocq
            ]
            ++ typedextraction-deps;

            patchPhase = ''
              patchShebangs ./configure.sh
              patchShebangs ./plugin/process_extraction.sh
            '';

            configurePhase =
              lib.optionalString (package == "all") pkgallMake
              + ''
                touch ${pkgpath}/_config
              ''
              + lib.optionalString (package == "single") ''
                ./configure.sh local
              '';

            preBuild = ''
              cd ${pkgpath}
            '';

            meta = {
              homepage = "https://peregrine-project.github.io/";
              description = "A framework for extracting Rocq programs to Rust and Elm";
              maintainers = with lib.maintainers; [ _4ever2 ];
              license = lib.licenses.mit;
            };
          }
          // lib.optionalAttrs (package != "single") {
            passthru = lib.mapAttrs (package: deps: typedextraction_ package) packages;
          }
        )
      );
    in
    derivation;
in
typedextraction_ (if single then "single" else "all")
