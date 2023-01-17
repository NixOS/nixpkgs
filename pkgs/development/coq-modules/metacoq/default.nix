{ lib, fetchzip,
  mkCoqDerivation, recurseIntoAttrs,  single ? false,
  coqPackages, coq, equations, version ? null }@args:
with builtins // lib;
let
  repo  = "metacoq";
  owner = "MetaCoq";
  defaultVersion = with versions; lib.switch coq.coq-version [
      { case = "8.11"; out = "1.0-beta2-8.11"; }
      { case = "8.12"; out = "1.0-beta2-8.12"; }
      # Do not provide 8.13 because it does not compile with equations 1.3 provided by default (only 1.2.3)
      # { case = "8.13"; out = "1.0-beta2-8.13"; }
      { case = "8.14"; out = "1.1-8.14"; }
      { case = "8.15"; out = "1.1-8.15"; }
      { case = "8.16"; out = "1.1-8.16"; }
    ] null;
  release = {
    "1.0-beta2-8.11".sha256 = "sha256-I9YNk5Di6Udvq5/xpLSNflfjRyRH8fMnRzbo3uhpXNs=";
    "1.0-beta2-8.12".sha256 = "sha256-I8gpmU9rUQJh0qfp5KOgDNscVvCybm5zX4TINxO1TVA=";
    "1.0-beta2-8.13".sha256 = "sha256-IC56/lEDaAylUbMCfG/3cqOBZniEQk8jmI053DBO5l8=";
    "1.0-8.14".sha256 = "sha256-iRnaNeHt22JqxMNxOGPPycrO9EoCVjusR2s0GfON1y0=";
    "1.0-8.15".sha256 = "sha256-8RUC5dHNfLJtJh+IZG4nPTAVC8ZKVh2BHedkzjwLf/k=";
    "1.0-8.16".sha256 = "sha256-7rkCAN4PNnMgsgUiiLe2TnAliknN75s2SfjzyKCib/o=";
    "1.1-8.14".sha256 = "sha256-6vViCNQl6BnGgOHX3P/OLfFXN4aUfv4RbDokfz2BgQI=";
    "1.1-8.15".sha256 = "sha256-qCD3wFW4E+8vSVk4XoZ0EU4PVya0al+JorzS9nzmR/0=";
    "1.1-8.16".sha256 = "sha256-cTK4ptxpPPlqxAhasZFX3RpSlsoTZwhTqs2A3BZy9sA=";
  };
  releaseRev = v: "v${v}";

  # list of core metacoq packages sorted by dependency order
  packages = [ "template-coq" "pcuic" "safechecker" "erasure" "all" ];

  template-coq = metacoq_ "template-coq";

  metacoq_ = package: let
      metacoq-deps = if package == "single" then []
        else map metacoq_ (head (splitList (lib.pred.equal package) packages));
      pkgpath = if package == "single" then "./" else "./${package}";
      pname = if package == "all" then "metacoq" else "metacoq-${package}";
      pkgallMake = ''
          mkdir all
          echo "all:" > all/Makefile
          echo "install:" >> all/Makefile
        '' ;
      derivation = (mkCoqDerivation ({
        inherit version pname defaultVersion release releaseRev repo owner;

        mlPlugin = true;
        propagatedBuildInputs = [ equations coq.ocamlPackages.zarith ] ++ metacoq-deps;

        patchPhase =  ''
          patchShebangs ./configure.sh
          patchShebangs ./template-coq/update_plugin.sh
          patchShebangs ./template-coq/gen-src/to-lower.sh
          patchShebangs ./pcuic/clean_extraction.sh
          patchShebangs ./safechecker/clean_extraction.sh
          patchShebangs ./erasure/clean_extraction.sh
          echo "CAMLFLAGS+=-w -60 # Unused module" >> ./safechecker/Makefile.plugin.local
          sed -i -e 's/mv $i $newi;/mv $i tmp; mv tmp $newi;/' ./template-coq/gen-src/to-lower.sh ./pcuic/clean_extraction.sh ./safechecker/clean_extraction.sh ./erasure/clean_extraction.sh
        '' ;

        configurePhase = optionalString (package == "all") pkgallMake + ''
          touch ${pkgpath}/metacoq-config
        '' + optionalString (elem package ["safechecker" "erasure"]) ''
          echo  "-I ${template-coq}/lib/coq/${coq.coq-version}/user-contrib/MetaCoq/Template/" > ${pkgpath}/metacoq-config
        '' + optionalString (package == "single") ''
          ./configure.sh local
        '';

        preBuild = ''
          cd ${pkgpath}
        '' ;

        meta = {
          homepage    = "https://metacoq.github.io/";
          license     = licenses.mit;
          maintainers = with maintainers; [ cohencyril ];
        };
      } // optionalAttrs (package != "single")
        { passthru = genAttrs packages metacoq_; })
      ).overrideAttrs (o:
        let requiresOcamlStdlibShims = versionAtLeast o.version "1.0-8.16" ||
                                       (o.version == "dev" && (versionAtLeast coq.coq-version "8.16" || coq.coq-version == "dev")) ;
        in
          {
            propagatedBuildInputs = o.propagatedBuildInputs ++ optional requiresOcamlStdlibShims coq.ocamlPackages.stdlib-shims;
          });
  in derivation;
in
metacoq_ (if single then "single" else "all")
