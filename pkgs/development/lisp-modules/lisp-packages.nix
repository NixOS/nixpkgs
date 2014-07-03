{stdenv, clwrapper, pkgs}:
let lispPackages = rec {
  inherit pkgs clwrapper stdenv;
  nixLib = pkgs.lib;
  callPackage = nixLib.callPackageWith lispPackages;

  buildLispPackage =  callPackage ./define-package.nix;

  cl-ppcre = buildLispPackage rec {
    baseName = "cl-ppcre";
    version = "2.0.4";
    description = "Regular expression library for Common Lisp";
    deps = [];
    src = pkgs.fetchurl {
      url = "https://github.com/edicl/cl-ppcre/archive/v${version}.tar.gz";
      sha256 = "16nkfg6j7nn8qkzxn462kqpdlbajpz2p55pdl12sia6yqkj3lh97";
    };
  };

  clx = buildLispPackage rec {
    baseName = "clx";
    version = "2013-09";
    description = "X11 bindings for Common Lisp";
    deps = [];
    src = pkgs.fetchgit {
      url = "https://github.com/sharplispers/clx.git";
      rev = "e2b762ac93d78d6eeca4f36698c8dfd1537ce998";
      sha256 = "0jcrmlaayz7m8ixgriq7id3pdklyk785qvpcxdpcp4aqnfiiqhij";
    };
  };

  iterate = buildLispPackage rec {
    baseName = "iterate";
    version = "1.4.3";
    description = "Iteration package for Common Lisp";
    deps = [];
    src = pkgs.fetchdarcs {
      url = "http://common-lisp.net/project/iterate/darcs/iterate";
      sha256 = "0m3q0s7h5s8varwx584m2akgdslj14df7kg4w1bj1fbgzsag5m1w";
      rev = version;
    };
    overrides = x: {
      configurePhase="buildPhase(){ true; }";
    };
  };

  stumpwm = callPackage ./stumpwm {};

  alexandria = buildLispPackage rec {
    baseName = "alexandria";
    version = "git-20131029";
    description = "Alexandria is a collection of portable public domain utilities.";
    deps = [];
    src = pkgs.fetchgit {
      url = "git://common-lisp.net/projects/alexandria/alexandria.git";
      sha256 = "1d981a243f9d4d3c9fd86cc47698050507ff615b87b9a710449abdb4234e501b";
      rev = ''2b1eb4067fb34bc501e527de75d09166a8ba9ceb'';
    };
  };

  esrap-peg = buildLispPackage rec {
    baseName = "esrap-peg";
    version = "git-20131029";
    description = "A wrapper around Esrap to allow generating Esrap grammars from PEG definitions";
    deps = [alexandria cl-unification esrap iterate];
    src = pkgs.fetchgit {
      url = "https://github.com/fb08af68/esrap-peg.git";
      sha256 = "48e616a697aca95e90e55052fdc9a7f96bf29b3208b1b4012fcd3189c2eceeb1";
      rev = ''1f2f21e32e618f71ed664cdc5e7005f8b6b0f7c8'';
      
      
    };
  };

  cl-unification = buildLispPackage rec {
    baseName = "cl-unification";
    version = "cvs-2013-10-28";
    description = "";
    deps = [];
    src = pkgs.fetchcvs {
      sha256 = "a574b7f9615232366e3e5e7ee400d60dbff23f6d0e1def5a3c77aafdfd786e6a";
      
      date = ''2013-10-28'';
      module = ''cl-unification'';
      cvsRoot = '':pserver:anonymous:anonymous@common-lisp.net:/project/cl-unification/cvsroot'';
    };
  };

  esrap = buildLispPackage rec {
    baseName = "esrap";
    version = "git-20131029";
    description = "A Packrat / Parsing Grammar / TDPL parser for Common Lisp.";
    deps = [alexandria];
    src = pkgs.fetchgit {
      url = "https://github.com/scymtym/esrap.git";
      sha256 = "c56616ac01be0f69e72902f9fd830a8af2c2fa9018b66747a5da3988ae38817f";
      rev = ''c71933b84e220f21e8a509ec26afe3e3871e2e26'';
      
      
    };
  };
};
in lispPackages
