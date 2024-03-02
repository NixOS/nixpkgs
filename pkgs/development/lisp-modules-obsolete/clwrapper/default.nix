{lib, stdenv, asdf, which, bash, lisp ? null}:
stdenv.mkDerivation {
  name = "cl-wrapper-script";

  buildPhase="";

  installPhase=''
    mkdir -p "$out"/bin
    export head="$(which head)"
    export ls="$(which ls)"
    substituteAll ${./common-lisp.sh} "$out"/bin/common-lisp.sh
    substituteAll "${./build-with-lisp.sh}" "$out/bin/build-with-lisp.sh"
    substituteAll "${./cl-wrapper.sh}" "$out/bin/cl-wrapper.sh"
    patchShebangs "$out/bin"
    chmod a+x "$out"/bin/*

    substituteAll "${./setup-hook.sh}" "setup-hook-parsed"
    addEnvHooks(){ true; };
    source setup-hook-parsed
    setLisp "${lisp}"
    echo "$NIX_LISP"

    mkdir -p "$out/lib/common-lisp/"
    cp -r "${asdf}/lib/common-lisp"/* "$out/lib/common-lisp/"
    chmod u+rw -R "$out/lib/common-lisp/"

    NIX_LISP_PRELAUNCH_HOOK='
      NIX_LISP_FASL_TYPE=lisp
      nix_lisp_run_single_form "(progn
        (uiop/lisp-build:compile-file* \"'"$out"'/lib/common-lisp/asdf/build/asdf.lisp\")
        (asdf:load-system :uiop :force :all)
        (asdf:load-system :asdf :force :all)
        (ignore-errors (asdf:load-system :uiop/version :force :all))
      )"' \
      "$out/bin/common-lisp.sh"
  '';

  buildInputs = [which];

  inherit asdf lisp bash;
  stdenv_shell = stdenv.shell;

  setupHook = ./setup-hook.sh;

  dontUnpack = true;

  ASDF_OUTPUT_TRANSLATIONS="${builtins.storeDir}/:${builtins.storeDir}";

  passthru = {
    inherit lisp;
  };

  meta = {
    description = "Script used to wrap Common Lisp implementations";
    maintainers = [lib.maintainers.raskin];
  };
}
