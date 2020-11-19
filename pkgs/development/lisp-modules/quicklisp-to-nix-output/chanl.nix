args @ { fetchurl, ... }:
rec {
  baseName = ''chanl'';
  version = ''20201016-git'';

  parasites = [ "chanl/examples" "chanl/tests" ];

  description = ''Communicating Sequential Process support for Common Lisp'';

  deps = [ args."alexandria" args."bordeaux-threads" args."fiveam" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/chanl/2020-10-16/chanl-20201016-git.tgz'';
    sha256 = ''13kmk6q20kkwy8z3fy0sv57076xf5nls3qx31yp47vaxhn9p11a1'';
  };

  packageName = "chanl";

  asdFilesToKeep = ["chanl.asd"];
  overrides = x: x;
}
/* (SYSTEM chanl DESCRIPTION
    Communicating Sequential Process support for Common Lisp SHA256
    13kmk6q20kkwy8z3fy0sv57076xf5nls3qx31yp47vaxhn9p11a1 URL
    http://beta.quicklisp.org/archive/chanl/2020-10-16/chanl-20201016-git.tgz
    MD5 7870137f4c905f64290634ae3d0aa3fd NAME chanl FILENAME chanl DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME fiveam FILENAME fiveam))
    DEPENDENCIES (alexandria bordeaux-threads fiveam) VERSION 20201016-git
    SIBLINGS NIL PARASITES (chanl/examples chanl/tests)) */
