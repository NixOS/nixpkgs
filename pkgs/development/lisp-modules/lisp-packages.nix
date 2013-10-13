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
      url = "https://github.com/sharplispers/clx/";
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
      tag=version;
    };
    overrides = x: {
      configurePhase="buildPhase(){ true; }";
    };
  };
};
in lispPackages
