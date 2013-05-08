args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;

  version = lib.attrByPath ["version"] "0.9.9" args; 
  buildInputs = with args; [
    libtool libjpeg openssl libX11 libXdamage xproto damageproto
    xextproto libXext fixesproto libXfixes xineramaproto libXinerama
    libXrandr randrproto libXtst zlib
  ];
in
rec {
  src = fetchurl {
    url = "http://downloads.sourceforge.net/libvncserver/LibVNCServer-${version}.tar.gz";
    sha256 = "1y83z31wbjivbxs60kj8a8mmjmdkgxlvr2x15yz95yy24lshs1ng";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "libvncserver-" + version;
  meta = {
    description = "VNC server library";
  };
}
