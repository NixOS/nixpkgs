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
    sha256 = "1hrk051yi1qixy0vdig99cbv0v0p825acli65s08yz99b0pjz7m5";
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
