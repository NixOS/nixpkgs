args @ { fetchurl, ... }:
rec {
  baseName = ''misc-extensions'';
  version = ''20150608-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/misc-extensions/2015-06-08/misc-extensions-20150608-git.tgz'';
    sha256 = ''0pkvi1l5djwpvm0p8m0bcdjm61gxvzy0vgn415gngdixvbbchdqj'';
  };

  packageName = "misc-extensions";

  asdFilesToKeep = ["misc-extensions.asd"];
  overrides = x: x;
}
/* (SYSTEM misc-extensions DESCRIPTION NIL SHA256
    0pkvi1l5djwpvm0p8m0bcdjm61gxvzy0vgn415gngdixvbbchdqj URL
    http://beta.quicklisp.org/archive/misc-extensions/2015-06-08/misc-extensions-20150608-git.tgz
    MD5 ef8a05dd4382bb9d1e3960aeb77e332e NAME misc-extensions FILENAME
    misc-extensions DEPS NIL DEPENDENCIES NIL VERSION 20150608-git SIBLINGS NIL
    PARASITES NIL) */
