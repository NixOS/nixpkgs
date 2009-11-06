a :  
let 
  buildInputs = with a; [
    mpfr m4 binutils emacs
    libX11 xproto inputproto libXi 
    libXext xextproto libXt libXaw libXmu
  ]; 
in
rec {
  src = a.fetchcvs {
    cvsRoot = ":pserver:anonymous@cvs.sv.gnu.org:/sources/gcl";
    module = "gcl";
    tag = "Version_2_6_8pre";
    date = "2009-11-05";
    sha256 = "5aa6c1616f585466a6aae91e38472f20539be4ce978fd458592e425904bdd9bc";
  };

  name = "gcl-2.6.8pre";
  inherit buildInputs;
  configureFlags = [];

  preBuild = a.fullDepEntry (''
    echo '(defun init_gcl_cmpmap (&rest args))' >> cmpnew/cmpmap.lsp
  '') ["minInit" "doUnpack"];

  /* doConfigure should be removed if not needed */
  phaseNames = ["preBuild" "doConfigure" "doMakeInstall"];
      
  meta = {
    description = "GNU Common Lisp compiler working via GCC";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      all;
  };
}
