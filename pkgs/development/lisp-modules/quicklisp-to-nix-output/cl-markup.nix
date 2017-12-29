args @ { fetchurl, ... }:
rec {
  baseName = ''cl-markup'';
  version = ''20131003-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-markup/2013-10-03/cl-markup-20131003-git.tgz'';
    sha256 = ''1ik3a5k6axq941zbf6zyig553i5gnypbcxdq9l7bfxp8w18vbj0r'';
  };

  packageName = "cl-markup";

  asdFilesToKeep = ["cl-markup.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-markup DESCRIPTION NIL SHA256
    1ik3a5k6axq941zbf6zyig553i5gnypbcxdq9l7bfxp8w18vbj0r URL
    http://beta.quicklisp.org/archive/cl-markup/2013-10-03/cl-markup-20131003-git.tgz
    MD5 3ec36b8e15435933f614959032987848 NAME cl-markup FILENAME cl-markup DEPS
    NIL DEPENDENCIES NIL VERSION 20131003-git SIBLINGS (cl-markup-test)
    PARASITES NIL) */
