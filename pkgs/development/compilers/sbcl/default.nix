a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "1.0.29" a; 
  buildInputs = with a; [
    clisp makeWrapper
  ];
in
rec {
  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/sbcl/sbcl-${version}-source.tar.bz2";
    sha256 = "1bdsn4rnrz289068f1bdnxyijs4r02if4p87fv726glp5wm20q1z";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["setVars" "doFixNewer" "doFixTests" "setVersion" "doBuild" "doInstall" "doWrap"];
      
  setVars = a.fullDepEntry (''
    export INSTALL_ROOT=$out
  '') ["minInit"];

  setVersion = a.fullDepEntry (''
    echo '"${version}.nixos"' > version.lisp-expr
    echo "
    (lambda (features)
      (flet ((enable (x)
               (pushnew x features))
             (disable (x)
               (setf features (remove x features))))
        (enable :sb-thread))) " > customize-target-features.lisp
  '') ["minInit" "doUnpack"];

  /* SBCL checks whether files are up-to-date in many places.. Unfortunately, same timestamp 
     is not good enought
  */
  doFixNewer = a.fullDepEntry(''
    sed -e 's@> x y@>= x y@' -i contrib/sb-aclrepl/repl.lisp
    sed -e '/(date)/i((= date 2208988801) 2208988800)' -i contrib/asdf/asdf.lisp
    sed -i src/cold/slam.lisp -e \
      '/file-write-date input/a)'
    sed -i src/cold/slam.lisp -e \
      '/file-write-date output/i(or (and (= 2208988801 (file-write-date output)) (= 2208988801 (file-write-date input)))'
    sed -i src/code/target-load.lisp -e \
      '/date defaulted-fasl/a)'
    sed -i src/code/target-load.lisp -e \
      '/date defaulted-source/i(or (and (= 2208988801 (file-write-date defaulted-source-truename)) (= 2208988801 (file-write-date defaulted-fasl-truename)))'
  '') ["minInit" "doUnpack"];

  doWrap = a.fullDepEntry (''
    wrapProgram "$out/bin/sbcl" --set "SBCL_HOME" "$out/lib/sbcl"
  '') ["minInit" "addInputs"];

  doFixTests = a.fullDepEntry (''
    sed -e 's/"sys"/"wheel"/' -i contrib/sb-posix/posix-tests.lisp
  '') ["minInit" "doUnpack"];

  doBuild = a.fullDepEntry (''
    sh make.sh clisp
  '') ["minInit" "doUnpack" "addInputs"];

  doInstall = a.fullDepEntry (''
    sh install.sh
  '') ["doBuild" "minInit" "addInputs"];

  name = "sbcl-" + version;
  meta = {
    description = "Lisp compiler";
    maintainers = [a.lib.maintainers.raskin];
  };
}


