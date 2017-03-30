{pkgs, buildLispPackage, quicklisp-to-nix-packages}:
{
  iterate = x: {
    overrides = x: {
      configurePhase="buildPhase(){ true; }";
    };
  };
  cl-fuse = x: {
    propagatedBuildInputs = [pkgs.fuse];
    overrides = x : {
      configurePhase = ''
        export CL_SOURCE_REGISTRY="$CL_SOURCE_REGISTRY:$PWD"
        export makeFlags="$makeFlags LISP=common-lisp.sh"
      '';
    };
  };
  hunchentoot = x: {
    propagatedBuildInputs = [pkgs.openssl];
  };
  iolib = x: {
    propagatedBuildInputs = [pkgs.libfixposix pkgs.gcc];
    overrides = y: {
      postBuild = ''
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :iolib)"' common-lisp.sh ""
      '';
    };
  };
}
