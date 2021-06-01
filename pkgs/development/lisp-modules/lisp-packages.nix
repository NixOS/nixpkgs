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
        url = "https://beta.quicklisp.org/dist/quicklisp/2021-04-11/distinfo.txt";
        sha256 = "sha256:1z7a7m9cm7iv4m9ajvyqphsw30s3qwb0l8g8ayfmkvmvhlj79g86";
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
    version = "2.0.0";

    description = "Browser";

    overrides = x: {
      patches = [
        # Fixes a startup crash on Darwin
        # https://github.com/atlas-engineer/nyxt/pull/1476
        (pkgs.fetchpatch {
          url = "https://github.com/midchildan/nyxt/commit/6184884b48b7cacdc51d104cb2299c26437a73d8.diff";
          sha256 = "sha256-A8Hwfjn/B5fv8OTKM5i9YrNFAMbPAg9xRH7gwoMMlQs=";
        })

        # Fix list-buffers
        (pkgs.fetchpatch {
          url = "https://github.com/atlas-engineer/nyxt/commit/4e2efb5a456d8d647f3eeaeb52cb21f96c92471c.diff";
          sha256 = "sha256-xt+jXZlTktznAoEWsaO5uQywo+bR9PecgTKOjY7UNvY=";
        })

        # Fix non-functional "Update" button in the buffer list
        # https://github.com/atlas-engineer/nyxt/pull/1484
        (pkgs.fetchpatch {
          url = "https://github.com/midchildan/nyxt/commit/7589181d6e367442bad8011f0ef5b42fc1cfd3c5.diff";
          sha256 = "sha256-4uXm7yxkhcArk39JBealGr1N4r/8AM5v/1VYHw1y4hw=";
        })
      ];

      postInstall = ''
        echo "Building nyxt binary"

        # clear unnecessary environment variables to avoid hitting the limit
        env -i \
        NIX_LISP="$NIX_LISP" \
        NIX_LISP_PRELAUNCH_HOOK='
          nix_lisp_build_system nyxt/gi-gtk-application \
            "(asdf/system:component-entry-point (asdf:find-system :nyxt/gi-gtk-application))" \
            "" \
            "(format *error-output* \"Alien objects:~%~s~%\" sb-alien::*shared-objects*)"
        ' "$out/bin/nyxt-lisp-launcher.sh"

        mv "$out/lib/common-lisp/nyxt/nyxt" "$out/bin/"
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
            cl-gobject-introspection
    ];
    src = pkgs.fetchFromGitHub {
      owner = "atlas-engineer";
      repo = "nyxt";
      rev = "${version}";
      sha256 = "sha256-eSRNfzkAzGTorLjdHo1LQEKLx4ASdv3RGXIFZ5WFIXk=";
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
