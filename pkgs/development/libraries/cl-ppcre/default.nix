args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;
  simplyShare = args.simplyShare;

  version = lib.getAttr ["version"] "2.0.0" args; 
  buildInputs = with args; [ ];
in
rec {
  src = fetchurl {
    url = http://weitz.de/files/cl-ppcre.tar.gz;
    sha256 = "14zxrmc4b4q9kg505y9lb0nqp80fpmpwn51xwkqiwkm361n6h23p";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = [(simplyShare "cl-ppcre")];
      
  name = "cl-ppcre-" + version;
  meta = {
    description = "Common Lisp Portable Perl Compatible RegExp library";
  };
}
