{stdenv, clwrapper, pkgs}:
let lispPackages = rec {
  inherit pkgs clwrapper stdenv;
  nixLib = pkgs.lib;
  callPackage = nixLib.callPackageWith lispPackages;

  buildLispPackage =  callPackage ./define-package.nix;

  esrap-peg = buildLispPackage rec {
    baseName = "esrap-peg";
    version = "git-20170320";
    description = "A wrapper around Esrap to allow generating Esrap grammars from PEG definitions";
    deps = with (pkgs.quicklispPackagesFor clwrapper); [alexandria cl-ppcre-template cl-unification esrap iterate];
    src = pkgs.fetchgit {
      url = "https://github.com/fb08af68/esrap-peg.git";
      sha256 = "15yiial7cy2nbgszqxd26qqcc6n3pw5qlrppzx0mfr3xbd9pvzby";
      rev = ''5a559b0030ecbf5e14cb070b0dc240535faa3402'';
    };
  };

  clx-xkeyboard = buildLispPackage rec {
    baseName = "clx-xkeyboard";
    testSystems = ["xkeyboard"];
    version = "git-20150523";
    description = "CLX support for X Keyboard extensions";
    deps = with (pkgs.quicklispPackagesFor clwrapper); [clx];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/filonenko-mikhail/clx-xkeyboard'';
      sha256 = "11b34da7d354a709a24774032e85a8947be023594f8a333eaff6d4aa79f2b3db";
      rev = ''11455d36283ef31c498bd58ffebf48c0f6b86ea6'';
    };
  };

  quicklisp = buildLispPackage rec {
    baseName = "quicklisp";
    version = "2016-01-21";

    testSystems = [];

    description = "The Common Lisp package manager";
    deps = [];
    src = pkgs.fetchgit {
      url = "https://github.com/quicklisp/quicklisp-client/";
      rev = "refs/tags/version-${version}";
      sha256 = "007r1ydbhrkh6ywqgpvzp0xg0yypgrfai3n4mn16gj5w2zz013lx";
    };
    overrides = x: rec {
      inherit clwrapper;
      quicklispdist = pkgs.fetchurl {
        # Will usually be replaced with a fresh version anyway, but needs to be
        # a valid distinfo.txt
        url = "http://beta.quicklisp.org/dist/quicklisp/2016-03-18/distinfo.txt";
        sha256 = "13mvign4rsicfvg3vs3vj1qcjvj2m1aqhq93ck0sgizxfcj5167m";
      };
      buildPhase = '' true; '';
      postInstall = ''
        substituteAll ${./quicklisp.sh} "$out"/bin/quicklisp
        chmod a+x "$out"/bin/quicklisp
        cp "${quicklispdist}" "$out/lib/common-lisp/quicklisp/quicklisp-distinfo.txt"
      '';
    };
  };
};
in lispPackages
