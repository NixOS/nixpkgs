args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;
  FullDepEntry = args.FullDepEntry;

  version = lib.getAttr ["version"] "" args; 
  buildInputs = with args; [
    libtiff libpng libjpeg pkgconfig 
    gtk glib
  ];
in
rec {
  src = fetchurl {
    url = ftp://ftp.debian.org/debian/pool/main/o/opencv/opencv_0.9.7.orig.tar.gz;
    sha256 = "14qnm59gn518gjxwjb9hm3ij0b1awlxa76qdvnn5ygxsx713lf2j";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doMakeInstall" "postInstall"];

  postInstall = FullDepEntry (''
    ln -s $out/include/opencv/* $out/include
  '') ["doMakeInstall" "minInit"];
      
  name = "libcv-" + version;
  meta = {
    description = "libcv - computer vision library";
  };
}
