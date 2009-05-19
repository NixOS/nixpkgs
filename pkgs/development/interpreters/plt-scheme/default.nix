args: with args; 
let version = lib.getAttr ["version"] "4.0.1" args; in
rec {
  src = fetchurl {
    url = "ftp://infogroep.be/pub/plt/bundles/${version}/plt/plt-${version}-src-unix.tgz";
    sha256 = "0qykfsh87gz50szcini0wyl25iqd6d2mhp6f20qkid9392bnv4c8";
  };

  buildInputs = [cairo fontconfig freetype libjpeg libpng openssl 
    libXaw libXft perl mesa libX11 libXrender libICE xproto renderproto 
    pixman libSM libxcb libXext xextproto libXmu libXt zlib which];
  configureFlags = ["--enable-shared" "--enable-pthreads" "--with-x"];
  goSrcDir = "cd src";

  /* doConfigure should be specified separately */
  phaseNames = ["preConfigure" "doConfigure" "doMakeInstall"];

  preConfigure = fullDepEntry (''
    sed -e 's@/usr/bin/uname@'"$(which uname)"'@g' -i configure
  '') ["minInit" "addInputs" "doUnpack"];
      
  name = "plt-scheme" + version;
  meta = {
    description = "PLT scheme environment";
    homepage = http://plt-scheme.org/ ;
    license = "LGPL-2.1";
    licenses = ["LGPL-2.1"];
  };
}
