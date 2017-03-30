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
  };
}
