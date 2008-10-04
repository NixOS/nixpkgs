args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;

  version = lib.getAttr ["version"] "0.9.1" args; 
  buildInputs = with args; [
    libtool libjpeg openssl libX11 libXdamage xproto damageproto
    xextproto libXext fixesproto libXfixes xineramaproto libXinerama
    libXrandr randrproto libXtst zlib
  ];
in
rec {
  src = fetchurl {
    url = "http://downloads.sourceforge.net/libvncserver/LibVNCServer-${version}.tar.gz";
    sha256 = "10pjhfv0vnfphy4bghygm1bfz983ca6y91mmpsyn1wy16zyagg8g";
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
