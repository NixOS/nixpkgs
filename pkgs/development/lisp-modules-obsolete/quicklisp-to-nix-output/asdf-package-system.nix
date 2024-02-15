/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "asdf-package-system";
  version = "20150608-git";

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/asdf-package-system/2015-06-08/asdf-package-system-20150608-git.tgz";
    sha256 = "17lfwfc15hcag8a2jsaxkx42wmz2mwkvxf6vb2h9cim7dwsnyy29";
  };

  packageName = "asdf-package-system";

  asdFilesToKeep = ["asdf-package-system.asd"];
  overrides = x: x;
}
/* (SYSTEM asdf-package-system DESCRIPTION System lacks description SHA256
    17lfwfc15hcag8a2jsaxkx42wmz2mwkvxf6vb2h9cim7dwsnyy29 URL
    http://beta.quicklisp.org/archive/asdf-package-system/2015-06-08/asdf-package-system-20150608-git.tgz
    MD5 9eee9d811aec4894843ac1d8ae6cbccd NAME asdf-package-system FILENAME
    asdf-package-system DEPS NIL DEPENDENCIES NIL VERSION 20150608-git SIBLINGS
    NIL PARASITES NIL) */
