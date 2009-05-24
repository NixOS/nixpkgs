args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;
  simplyShare = args.simplyShare;

  version = lib.attrByPath ["version"] "2.0.0" args; 
  buildInputs = with args; [ ];
in
rec {
  src = fetchurl {
    url = http://weitz.de/files/cl-ppcre.tar.gz;
    sha256 = "10698b7cmap4hk1lmlsvx2adcgsni5gly98qpj19fsdgy9ic7dhv";
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
