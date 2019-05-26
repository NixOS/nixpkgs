{stdenv, clwrapper, pkgs, sbcl, coreutils, nix, asdf}:
let lispPackages = rec {
  inherit pkgs clwrapper stdenv;
  nixLib = pkgs.lib;
  callPackage = nixLib.callPackageWith lispPackages;

  buildLispPackage =  callPackage ./define-package.nix;

  quicklisp = buildLispPackage rec {
    baseName = "quicklisp";
    version = "2017-03-06";

    buildSystems = [];

    description = "The Common Lisp package manager";
    deps = [];
    src = pkgs.fetchgit {
      url = "https://github.com/quicklisp/quicklisp-client/";
      rev = "refs/tags/version-${version}";
      sha256 = "11ywk7ggc1axivpbqvrd7m1lxsj4yp38d1h9w1d8i9qnn7zjpqj4";
    };
    overrides = x: rec {
      inherit clwrapper;
      quicklispdist = pkgs.fetchurl {
        # Will usually be replaced with a fresh version anyway, but needs to be
        # a valid distinfo.txt
        url = "https://beta.quicklisp.org/dist/quicklisp/2019-01-07/distinfo.txt";
        sha256 = "1f0giy182p6qlmmqljir92566c8l1g2sv41cbzv86s3kv0j640fd";
      };
      buildPhase = '' true; '';
      postInstall = ''
        substituteAll ${./quicklisp.sh} "$out"/bin/quicklisp
        chmod a+x "$out"/bin/quicklisp
        cp "${quicklispdist}" "$out/lib/common-lisp/quicklisp/quicklisp-distinfo.txt"
      '';
    };
  };

  quicklisp-to-nix-system-info = stdenv.mkDerivation rec {
    name = "quicklisp-to-nix-system-info-${version}";
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

  quicklisp-to-nix = stdenv.mkDerivation rec {
    name = "quicklisp-to-nix-${version}";
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
};
in lispPackages
