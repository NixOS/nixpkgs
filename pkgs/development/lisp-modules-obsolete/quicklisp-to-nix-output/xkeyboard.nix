/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "xkeyboard";
  version = "clx-20120811-git";

  parasites = [ "xkeyboard-test" ];

  description = "XKeyboard is X11 extension for clx of the same name.";

  deps = [ args."clx" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clx-xkeyboard/2012-08-11/clx-xkeyboard-20120811-git.tgz";
    sha256 = "11q70drx3xn7rvk528qlnzpnxd6hg6801kc54ys3jz1l7074458n";
  };

  packageName = "xkeyboard";

  asdFilesToKeep = ["xkeyboard.asd"];
  overrides = x: x;
}
/* (SYSTEM xkeyboard DESCRIPTION
    XKeyboard is X11 extension for clx of the same name. SHA256
    11q70drx3xn7rvk528qlnzpnxd6hg6801kc54ys3jz1l7074458n URL
    http://beta.quicklisp.org/archive/clx-xkeyboard/2012-08-11/clx-xkeyboard-20120811-git.tgz
    MD5 4e382b34e05d33f5de8e9c9dea33131c NAME xkeyboard FILENAME xkeyboard DEPS
    ((NAME clx FILENAME clx)) DEPENDENCIES (clx) VERSION clx-20120811-git
    SIBLINGS NIL PARASITES (xkeyboard-test)) */
