{ fetchurl, ... }:
rec {
  baseName = ''asdf-finalizers'';
  version = ''20170403-git'';

  description = ''Enforced calling of finalizers for Lisp code'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/asdf-finalizers/2017-04-03/asdf-finalizers-20170403-git.tgz'';
    sha256 = ''1w2ka0123icbjba7ngdd6h93j72g236h6jw4bsmvsak69fj0ybxj'';
  };

  packageName = "asdf-finalizers";

  asdFilesToKeep = ["asdf-finalizers.asd"];
  overrides = x: x;
}
/* (SYSTEM asdf-finalizers DESCRIPTION
    Enforced calling of finalizers for Lisp code SHA256
    1w2ka0123icbjba7ngdd6h93j72g236h6jw4bsmvsak69fj0ybxj URL
    http://beta.quicklisp.org/archive/asdf-finalizers/2017-04-03/asdf-finalizers-20170403-git.tgz
    MD5 a9e3c960e6b6fdbd69640b520ef8044b NAME asdf-finalizers FILENAME
    asdf-finalizers DEPS NIL DEPENDENCIES NIL VERSION 20170403-git SIBLINGS
    (asdf-finalizers-test list-of) PARASITES NIL) */
