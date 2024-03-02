/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-svg";
  version = "20180228-git";

  description = "Produce Scalable Vector Graphics (SVG) files";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-svg/2018-02-28/cl-svg-20180228-git.tgz";
    sha256 = "1ir299yg7210y1hwqs0di3gznj8ahsw16kf1n4yhfq78jswkrx48";
  };

  packageName = "cl-svg";

  asdFilesToKeep = ["cl-svg.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-svg DESCRIPTION Produce Scalable Vector Graphics (SVG) files
    SHA256 1ir299yg7210y1hwqs0di3gznj8ahsw16kf1n4yhfq78jswkrx48 URL
    http://beta.quicklisp.org/archive/cl-svg/2018-02-28/cl-svg-20180228-git.tgz
    MD5 672145ecadef2259a3833886dbe68617 NAME cl-svg FILENAME cl-svg DEPS NIL
    DEPENDENCIES NIL VERSION 20180228-git SIBLINGS NIL PARASITES NIL) */
