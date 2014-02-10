{stdenv, fetchurl, asdf, lisp ? null}:
stdenv.mkDerivation {
  name = "cl-wrapper-script";

  buildPhase="";

  installPhase=''
    mkdir -p "$out"/bin
    cp ${./cl-wrapper.sh} "$out"/bin/cl-wrapper.sh
    cp ${./common-lisp.sh} "$out"/bin/common-lisp.sh
    chmod a+x "$out"/bin/*
  '';

  inherit asdf lisp;

  setupHook = ./setup-hook.sh;

  phases="installPhase fixupPhase";

  preferLocalBuild = true;

  passthru = {
    inherit lisp;
  };

  meta = {
    description = ''Script used to wrap Common Lisp implementations'';
    maintainers = [stdenv.lib.maintainers.raskin];
  };
}
