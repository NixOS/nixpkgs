{lib, stdenv, clwrapper, pkgs, sbcl, coreutils, nix, asdf}:
let lispPackages = rec {
  inherit lib pkgs clwrapper stdenv;
  nixLib = pkgs.lib;
  callPackage = nixLib.callPackageWith lispPackages;

  buildLispPackage =  callPackage ./define-package.nix;

  quicklisp = buildLispPackage rec {
    baseName = "quicklisp";
    version = "2021-02-13";

    buildSystems = [];

    description = "The Common Lisp package manager";
    deps = [];
    src = pkgs.fetchgit {
      url = "https://github.com/quicklisp/quicklisp-client/";
      rev = "refs/tags/version-${version}";
      sha256 = "sha256:102f1chpx12h5dcf659a9kzifgfjc482ylf73fg1cs3w34zdawnl";
    };
    overrides = x: rec {
      inherit clwrapper;
      quicklispdist = pkgs.fetchurl {
        # Will usually be replaced with a fresh version anyway, but needs to be
        # a valid distinfo.txt
        url = "https://beta.quicklisp.org/dist/quicklisp/2021-02-28/distinfo.txt";
        sha256 = "sha256:1apc0s07fmm386rj866dbrhrkq3lrbgbd79kwcyp91ix7sza8z3z";
      };
      buildPhase = "true; ";
      postInstall = ''
        substituteAll ${./quicklisp.sh} "$out"/bin/quicklisp
        chmod a+x "$out"/bin/quicklisp
        cp "${quicklispdist}" "$out/lib/common-lisp/quicklisp/quicklisp-distinfo.txt"
      '';
    };
  };

  quicklisp-to-nix-system-info = stdenv.mkDerivation {
    pname = "quicklisp-to-nix-system-info";
    version = "1.0.0";
    src = ./quicklisp-to-nix;
    nativeBuildInputs = [sbcl];
    buildInputs = [
      lispPackages.quicklisp coreutils
    ];
    touch = coreutils;
    nix-prefetch-url = nix;
    inherit quicklisp;
    buildPhase = ''
      ${sbcl}/bin/sbcl --eval '(load #P"${asdf}/lib/common-lisp/asdf/build/asdf.lisp")' --load $src/system-info.lisp --eval '(ql-to-nix-system-info::dump-image)'
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp quicklisp-to-nix-system-info $out/bin
    '';
    dontStrip = true;
  };

  quicklisp-to-nix = stdenv.mkDerivation {
    pname = "quicklisp-to-nix";
    version = "1.0.0";
    src = ./quicklisp-to-nix;
    buildDependencies = [sbcl quicklisp-to-nix-system-info];
    buildInputs = with pkgs.lispPackages; [md5 cl-emb alexandria external-program];
    touch = coreutils;
    nix-prefetch-url = nix;
    inherit quicklisp;
    deps = [];
    system-info = quicklisp-to-nix-system-info;
    buildPhase = ''
      ${clwrapper}/bin/cl-wrapper.sh "${sbcl}/bin/sbcl" --eval '(load #P"${asdf}/lib/common-lisp/asdf/build/asdf.lisp")' --load $src/ql-to-nix.lisp --eval '(ql-to-nix::dump-image)'
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp quicklisp-to-nix $out/bin
    '';
    dontStrip = true;
  };

  clx-truetype = buildLispPackage rec {
          baseName = "clx-truetype";
          version = "20160825-git";

          buildSystems = [ "clx-truetype" ];
          parasites = [ "clx-truetype-test" ];

          description = "clx-truetype is pure common lisp solution for antialiased TrueType font rendering using CLX and XRender extension.";
          deps = with pkgs.lispPackages; [
                  alexandria bordeaux-threads cl-aa cl-fad cl-paths cl-paths-ttf cl-store
                          cl-vectors clx trivial-features zpb-ttf
          ];
          src = pkgs.fetchurl {
                  url = "http://beta.quicklisp.org/archive/clx-truetype/2016-08-25/clx-truetype-20160825-git.tgz";
                  sha256 = "0ndy067rg9w6636gxwlpnw7f3ck9nrnjb03444pprik9r3c9in67";
          };

          packageName = "clx-truetype";

          asdFilesToKeep = ["clx-truetype.asd"];
  };
  cluffer = buildLispPackage rec {
    baseName = "cluffer";
    version = "2018-09-24";

    buildSystems = [ "cluffer-base" "cluffer-simple-buffer" "cluffer-simple-line" "cluffer-standard-buffer" "cluffer-standard-line" "cluffer" ];
    parasites = [ "cluffer-test" ];

    description = "General purpose text-editor buffer";
    deps = with pkgs.lispPackages; [
      acclimation clump
    ];
    src = pkgs.fetchFromGitHub {
      owner = "robert-strandh";
      repo = "cluffer";
      rev = "4aad29c276a58a593064e79972ee4d77cae0af4a";
      sha256 = "1bcg13g7qb3dr8z50aihdjqa6miz5ivlc9wsj2csgv1km1mak2kj";
      # date = 2018-09-24T04:45:36+02:00;
    };

    packageName = "cluffer";

    asdFilesToKeep = [ "cluffer.asd" "cluffer-base.asd" "cluffer-simple-buffer.asd" "cluffer-simple-line.asd" "cluffer-standard-buffer.asd" "cluffer-standard-line.asd" ];
  };
  nyxt = pkgs.lispPackages.buildLispPackage rec {
    baseName = "nyxt";
    version = "2021-03-27";


    description = "Browser";

    overrides = x: {
      postInstall = ''
        echo "Building nyxt binary"
        NIX_LISP_PRELAUNCH_HOOK='
          nix_lisp_build_system nyxt/gtk-application \
           "(asdf/system:component-entry-point (asdf:find-system :nyxt/gtk-application))" \
           "" "(format *error-output* \"Alien objects:~%~s~%\" sb-alien::*shared-objects*)"
        ' "$out/bin/nyxt-lisp-launcher.sh"
        cp "$out/lib/common-lisp/nyxt/nyxt" "$out/bin/"
      '';
    };

    deps = with pkgs.lispPackages; [
            alexandria
            bordeaux-threads
            calispel
            cl-css
            cl-json
            cl-markup
            cl-ppcre
            cl-ppcre-unicode
            cl-prevalence
            closer-mop
            cl-containers
            cluffer
            moptilities
            dexador
            enchant
            file-attributes
            iolib
            local-time
            log4cl
            mk-string-metrics
            osicat
            parenscript
            quri
            serapeum
            str
            plump
            swank
            trivia
            trivial-clipboard
            trivial-features
            trivial-package-local-nicknames
            trivial-types
            unix-opts
            cl-html-diff
            hu_dot_dwim_dot_defclass-star
            cl-custom-hash-table
            fset
            cl-cffi-gtk
            cl-webkit2
    ];
    src = pkgs.fetchFromGitHub {
      owner = "atlas-engineer";
      repo = "nyxt";
      rev = "8ef171fd1eb62d168defe4a2d7115393230314d1";
      sha256 = "sha256:1dz55mdmj68kmllih7ab70nmp0mwzqp9lh3im7kcjfmc1r64irdv";
      # date = 2021-03-27T09:10:00+00:00;
    };

    packageName = "nyxt";

    propagatedBuildInputs = [
      pkgs.libressl.out
      pkgs.webkitgtk
      pkgs.sbcl
    ];
  };
};
in lispPackages
