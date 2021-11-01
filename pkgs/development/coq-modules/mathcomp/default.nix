############################################################################
# This file mainly provides the `mathcomp` derivation, which is            #
# essentially a meta-package containing all core mathcomp libraries        #
# (ssreflect fingroup algebra solvable field character). They can be       #
# accessed individually through the passthrough attributes of mathcomp     #
# bearing the same names (mathcomp.ssreflect, etc).                        #
############################################################################
# Compiling a custom version of mathcomp using `mathcomp.override`.        #
# This is the replacement for the former `mathcomp_ config` function.      #
# See the documentation at doc/languages-frameworks/coq.section.md.        #
############################################################################

{ lib, ncurses, which, graphviz, lua, fetchzip,
  mkCoqDerivation, recurseIntoAttrs, withDoc ? false, single ? false,
  coqPackages, coq, ocamlPackages, version ? null }@args:
with builtins // lib;
let
  repo  = "math-comp";
  owner = "math-comp";
  withDoc = single && (args.withDoc or false);
  defaultVersion = with versions; switch coq.coq-version [
      { case = isGe  "8.14";        out = "1.13.0"; }
      { case = range "8.10" "8.13"; out = "1.12.0"; }
      { case = range "8.7"  "8.12"; out = "1.11.0"; }
      { case = range "8.7" "8.11";  out = "1.10.0"; }
      { case = range "8.7" "8.11";  out = "1.9.0";  }
      { case = range "8.7" "8.9";   out = "1.8.0";  }
      { case = range "8.6" "8.9";   out = "1.7.0";  }
      { case = range "8.5" "8.7";   out = "1.6.4";  }
    ] null;
  release = {
    "1.13.0".sha256 = "0j4cz2y1r1aw79snkcf1pmicgzf8swbaf9ippz0vg99a572zqzri";
    "1.12.0".sha256 = "1ccfny1vwgmdl91kz5xlmhq4wz078xm4z5wpd0jy5rn890dx03wp";
    "1.11.0".sha256 = "06a71d196wd5k4wg7khwqb7j7ifr7garhwkd54s86i0j7d6nhl3c";
    "1.10.0".sha256 = "1b9m6pwxxyivw7rgx82gn5kmgv2mfv3h3y0mmjcjfypi8ydkrlbv";
    "1.9.0".sha256  = "0lid9zaazdi3d38l8042lczb02pw5m9wq0yysiilx891hgq2p81r";
    "1.8.0".sha256  = "07l40is389ih8bi525gpqs3qp4yb2kl11r9c8ynk1ifpjzpnabwp";
    "1.7.0".sha256  = "0wnhj9nqpx2bw6n1l4i8jgrw3pjajvckvj3lr4vzjb3my2lbxdd1";
    "1.6.4".sha256  = "09ww48qbjsvpjmy1g9yhm0rrkq800ffq21p6fjkbwd34qvd82raz";
    "1.6.1".sha256  = "1ilw6vm4dlsdv9cd7kmf0vfrh2kkzr45wrqr8m37miy0byzr4p9i";
  };
  releaseRev = v: "mathcomp-${v}";

  # list of core mathcomp packages sorted by dependency order
  packages = [ "ssreflect" "fingroup" "algebra" "solvable" "field" "character" "all" ];

  mathcomp_ = package: let
      mathcomp-deps = if package == "single" then []
        else map mathcomp_ (head (splitList (pred.equal package) packages));
      pkgpath = if package == "single" then "mathcomp" else "mathcomp/${package}";
      pname = if package == "single" then "mathcomp" else "mathcomp-${package}";
      pkgallMake = ''
        echo "all.v"  > Make
        echo "-I ." >>   Make
        echo "-R . mathcomp.all" >> Make
      '';
      derivation = mkCoqDerivation ({
        inherit version pname defaultVersion release releaseRev repo owner;

        nativeBuildInputs = optionals withDoc [ graphviz lua ];
        mlPlugin = versions.isLe "8.6" coq.coq-version;
        extraBuildInputs = [ ncurses which ];
        propagatedBuildInputs = mathcomp-deps;

        buildFlags = optional withDoc "doc";

        preBuild = ''
          if [[ -f etc/utils/ssrcoqdep ]]
          then patchShebangs etc/utils/ssrcoqdep
          fi
          if [[ -f etc/buildlibgraph ]]
          then patchShebangs etc/buildlibgraph
          fi
        '' + ''
          cd ${pkgpath}
        '' + optionalString (package == "all") pkgallMake;

        meta = {
          homepage    = "https://math-comp.github.io/";
          license     = licenses.cecill-b;
          maintainers = with maintainers; [ vbgl jwiegley cohencyril ];
        };
      } // optionalAttrs (package != "single")
        { passthru = genAttrs packages mathcomp_; }
        // optionalAttrs withDoc {
            htmldoc_template =
              fetchzip {
                url = "https://github.com/math-comp/math-comp.github.io/archive/doc-1.12.0.zip";
                sha256 = "0y1352ha2yy6k2dl375sb1r68r1qi9dyyy7dyzj5lp9hxhhq69x8";
              };
            postBuild = ''
              cp -rf _build_doc/* .
              rm -r _build_doc
            '';
            postInstall =
              let tgt = "$out/share/coq/${coq.coq-version}/"; in
              optionalString withDoc ''
              mkdir -p ${tgt}
              cp -r htmldoc ${tgt}
              cp -r $htmldoc_template/htmldoc_template/* ${tgt}/htmldoc/
            '';
            buildTargets = "doc";
            extraInstallFlags = [ "-f Makefile.coq" ];
          });
    patched-derivation1 = derivation.overrideAttrs (o:
      optionalAttrs (o.pname != null && o.pname == "mathcomp-all" &&
         o.version != null && o.version != "dev" && versions.isLt "1.7" o.version)
      { preBuild = ""; buildPhase = ""; installPhase = "echo doing nothing"; }
    );
    patched-derivation = patched-derivation1.overrideAttrs (o:
      optionalAttrs (versions.isLe "8.7" coq.coq-version ||
            (o.version != "dev" && versions.isLe "1.7" o.version))
      {
        installFlags = o.installFlags ++ [ "-f Makefile.coq" ];
      }
    );
    in patched-derivation;
in
mathcomp_ (if single then "single" else "all")
