/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "abstract-classes";
  version = "cl-20190307-hg";

  description = "Extends the MOP to allow `abstract` and `final` classes.";

  deps = [ args."closer-mop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-abstract-classes/2019-03-07/cl-abstract-classes-20190307-hg.tgz";
    sha256 = "0p0ml54j049anzjhdp54q36p3pbwqdikvyi9rk9jv6kxrgd07qdx";
  };

  packageName = "abstract-classes";

  asdFilesToKeep = ["abstract-classes.asd"];
  overrides = x: x;
}
/* (SYSTEM abstract-classes DESCRIPTION
    Extends the MOP to allow `abstract` and `final` classes. SHA256
    0p0ml54j049anzjhdp54q36p3pbwqdikvyi9rk9jv6kxrgd07qdx URL
    http://beta.quicklisp.org/archive/cl-abstract-classes/2019-03-07/cl-abstract-classes-20190307-hg.tgz
    MD5 9f70affac8015d8fc4e29f16c642890e NAME abstract-classes FILENAME
    abstract-classes DEPS ((NAME closer-mop FILENAME closer-mop)) DEPENDENCIES
    (closer-mop) VERSION cl-20190307-hg SIBLINGS (singleton-classes) PARASITES
    NIL) */
