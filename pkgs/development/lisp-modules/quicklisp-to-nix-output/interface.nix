/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "interface";
  version = "20190307-hg";

  description = "A system for defining interfaces.";

  deps = [ args."alexandria" args."global-vars" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/interface/2019-03-07/interface-20190307-hg.tgz";
    sha256 = "0h9i6vmc89yaiba2l3yh47gq8vnj7lmfky8g1pp96ky53h043608";
  };

  packageName = "interface";

  asdFilesToKeep = ["interface.asd"];
  overrides = x: x;
}
/* (SYSTEM interface DESCRIPTION A system for defining interfaces. SHA256
    0h9i6vmc89yaiba2l3yh47gq8vnj7lmfky8g1pp96ky53h043608 URL
    http://beta.quicklisp.org/archive/interface/2019-03-07/interface-20190307-hg.tgz
    MD5 2171f1127f13b79c82c56302b629c18b NAME interface FILENAME interface DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME global-vars FILENAME global-vars))
    DEPENDENCIES (alexandria global-vars) VERSION 20190307-hg SIBLINGS NIL
    PARASITES NIL) */
