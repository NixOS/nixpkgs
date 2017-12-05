args @ { fetchurl, ... }:
rec {
  baseName = ''hu_dot_dwim_dot_asdf'';
  version = ''20170630-darcs'';

  description = ''Various ASDF extensions such as attached test and documentation system, explicit development support, etc.'';

  deps = [ args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/hu.dwim.asdf/2017-06-30/hu.dwim.asdf-20170630-darcs.tgz'';
    sha256 = ''151l4s0cd6jxhz1q635zhyq48b1sz9ns88agj92r0f2q8igdx0fb'';
  };

  packageName = "hu.dwim.asdf";

  asdFilesToKeep = ["hu.dwim.asdf.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.asdf DESCRIPTION
    Various ASDF extensions such as attached test and documentation system, explicit development support, etc.
    SHA256 151l4s0cd6jxhz1q635zhyq48b1sz9ns88agj92r0f2q8igdx0fb URL
    http://beta.quicklisp.org/archive/hu.dwim.asdf/2017-06-30/hu.dwim.asdf-20170630-darcs.tgz
    MD5 b086cb36b6a88641497b20c39937c9d4 NAME hu.dwim.asdf FILENAME
    hu_dot_dwim_dot_asdf DEPS ((NAME uiop FILENAME uiop)) DEPENDENCIES (uiop)
    VERSION 20170630-darcs SIBLINGS (hu.dwim.asdf.documentation) PARASITES NIL) */
