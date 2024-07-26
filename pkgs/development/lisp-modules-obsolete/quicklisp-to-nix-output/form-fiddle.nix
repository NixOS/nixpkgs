/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "form-fiddle";
  version = "20190710-git";

  description = "A collection of utilities to destructure lambda forms.";

  deps = [ args."documentation-utils" args."trivial-indent" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/form-fiddle/2019-07-10/form-fiddle-20190710-git.tgz";
    sha256 = "12zmqm2vls043kaka7jp6pnsvkxlyv6x183yjyrs8jk461qfydwl";
  };

  packageName = "form-fiddle";

  asdFilesToKeep = ["form-fiddle.asd"];
  overrides = x: x;
}
/* (SYSTEM form-fiddle DESCRIPTION
    A collection of utilities to destructure lambda forms. SHA256
    12zmqm2vls043kaka7jp6pnsvkxlyv6x183yjyrs8jk461qfydwl URL
    http://beta.quicklisp.org/archive/form-fiddle/2019-07-10/form-fiddle-20190710-git.tgz
    MD5 2576065de1e3c95751285fb155f5bcf6 NAME form-fiddle FILENAME form-fiddle
    DEPS
    ((NAME documentation-utils FILENAME documentation-utils)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (documentation-utils trivial-indent) VERSION 20190710-git
    SIBLINGS NIL PARASITES NIL) */
