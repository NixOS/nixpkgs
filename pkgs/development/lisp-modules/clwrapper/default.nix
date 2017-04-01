{stdenv, fetchurl, asdf, lisp ? null}:
stdenv.mkDerivation {
  name = "cl-wrapper-script";

  buildPhase="";

  installPhase=''
    mkdir -p "$out"/bin
    substituteAll ${./common-lisp.sh} "$out"/bin/common-lisp.sh
    substituteAll "${./build-with-lisp.sh}" "$out/bin/build-with-lisp.sh"
    substituteAll "${./cl-wrapper.sh}" "$out/bin/cl-wrapper.sh"
    chmod a+x "$out"/bin/*
    
    substituteAll "${./setup-hook.sh}" "setup-hook-parsed"
    source setup-hook-parsed
    setLisp "${lisp}"
    echo "$NIX_LISP"

    ASDF_OUTPUT_TRANSLATIONS="${asdf}/lib/common-lisp/:$out/lib/common-lisp-compiled/" \
    NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(progn 
        (uiop/lisp-build:compile-file* \"${asdf}/lib/common-lisp/asdf/build/asdf.lisp\")
        (asdf:load-system :uiop :force :all)
        (asdf:load-system :asdf :force :all)
      )"' \
      "$out/bin/common-lisp.sh" "$NIX_LISP"

    ln -s "$out/lib/common-lisp-compiled"/{asdf/uiop,uiop}
  '';

  inherit asdf lisp;
  stdenv_shell = stdenv.shell;

  setupHook = ./setup-hook.sh;

  phases="installPhase fixupPhase";

  preferLocalBuild = true;

  passthru = {
    inherit lisp asdf;
  };

  meta = {
    description = ''Script used to wrap Common Lisp implementations'';
    maintainers = [stdenv.lib.maintainers.raskin];
  };
}
