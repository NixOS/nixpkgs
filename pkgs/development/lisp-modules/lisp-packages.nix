{stdenv, clwrapper, pkgs, sbcl, coreutils, nix, asdf}:
let lispPackages = rec {
  inherit pkgs clwrapper stdenv;
  nixLib = pkgs.lib;
  callPackage = nixLib.callPackageWith lispPackages;

  buildLispPackage =  callPackage ./define-package.nix;

  quicklisp = buildLispPackage rec {
    baseName = "quicklisp";
    version = "2019-02-16";

    buildSystems = [];

    description = "The Common Lisp package manager";
    deps = [];
    src = pkgs.fetchgit {
      url = "https://github.com/quicklisp/quicklisp-client/";
      rev = "refs/tags/version-${version}";
      sha256 = "0x9b4vf36n2hh102gqgjxg5f5ymxcr9j5khn4rskjdprfgd8d1y9";
    };
    overrides = x: rec {
      inherit clwrapper;
      quicklispdist = pkgs.fetchurl {
        # Will usually be replaced with a fresh version anyway, but needs to be
        # a valid distinfo.txt
        url = "https://beta.quicklisp.org/dist/quicklisp/2019-12-27/distinfo.txt";
        sha256 = "0fz0k7ydmddxvxyid0nkifap21n6bxap602qhqsac2dxglv3i4cs";
      };
      buildPhase = '' true; '';
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
};
in lispPackages
