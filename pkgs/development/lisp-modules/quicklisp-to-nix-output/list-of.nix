args @ { fetchurl, ... }:
{
  baseName = ''list-of'';
  version = ''asdf-finalizers-20170403-git'';

  description = ''magic list-of deftype'';

  deps = [ args."asdf-finalizers" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/asdf-finalizers/2017-04-03/asdf-finalizers-20170403-git.tgz'';
    sha256 = ''1w2ka0123icbjba7ngdd6h93j72g236h6jw4bsmvsak69fj0ybxj'';
  };

  packageName = "list-of";

  asdFilesToKeep = ["list-of.asd"];
  overrides = x: x;
}
/* (SYSTEM list-of DESCRIPTION magic list-of deftype SHA256
    1w2ka0123icbjba7ngdd6h93j72g236h6jw4bsmvsak69fj0ybxj URL
    http://beta.quicklisp.org/archive/asdf-finalizers/2017-04-03/asdf-finalizers-20170403-git.tgz
    MD5 a9e3c960e6b6fdbd69640b520ef8044b NAME list-of FILENAME list-of DEPS
    ((NAME asdf-finalizers FILENAME asdf-finalizers)) DEPENDENCIES
    (asdf-finalizers) VERSION asdf-finalizers-20170403-git SIBLINGS
    (asdf-finalizers-test asdf-finalizers) PARASITES NIL) */
