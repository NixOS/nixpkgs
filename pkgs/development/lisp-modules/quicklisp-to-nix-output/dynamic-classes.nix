args @ { fetchurl, ... }:
{
  baseName = ''dynamic-classes'';
  version = ''20130128-git'';

  description = '''';

  deps = [ args."metatilities-base" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/dynamic-classes/2013-01-28/dynamic-classes-20130128-git.tgz'';
    sha256 = ''0i2b9k8f8jgn86kz503z267w0zv4gdqajzw755xwhqfaknix74sa'';
  };

  packageName = "dynamic-classes";

  asdFilesToKeep = ["dynamic-classes.asd"];
  overrides = x: x;
}
/* (SYSTEM dynamic-classes DESCRIPTION NIL SHA256
    0i2b9k8f8jgn86kz503z267w0zv4gdqajzw755xwhqfaknix74sa URL
    http://beta.quicklisp.org/archive/dynamic-classes/2013-01-28/dynamic-classes-20130128-git.tgz
    MD5 a6ed01c4f21df2b6a142328b24ac7ba3 NAME dynamic-classes FILENAME
    dynamic-classes DEPS ((NAME metatilities-base FILENAME metatilities-base))
    DEPENDENCIES (metatilities-base) VERSION 20130128-git SIBLINGS
    (dynamic-classes-test) PARASITES NIL) */
