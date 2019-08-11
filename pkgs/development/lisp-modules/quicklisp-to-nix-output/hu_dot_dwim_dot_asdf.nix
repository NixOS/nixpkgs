args @ { fetchurl, ... }:
rec {
  baseName = ''hu_dot_dwim_dot_asdf'';
  version = ''20180228-darcs'';

  description = ''Various ASDF extensions such as attached test and documentation system, explicit development support, etc.'';

  deps = [ args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/hu.dwim.asdf/2018-02-28/hu.dwim.asdf-20180228-darcs.tgz'';
    sha256 = ''19ak3krzlzbdh8chbimwjca8q4jksaf9v88k86jsdgxchfr0dkld'';
  };

  packageName = "hu.dwim.asdf";

  asdFilesToKeep = ["hu.dwim.asdf.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.asdf DESCRIPTION
    Various ASDF extensions such as attached test and documentation system, explicit development support, etc.
    SHA256 19ak3krzlzbdh8chbimwjca8q4jksaf9v88k86jsdgxchfr0dkld URL
    http://beta.quicklisp.org/archive/hu.dwim.asdf/2018-02-28/hu.dwim.asdf-20180228-darcs.tgz
    MD5 a1f3085cbd7ea77f9212112cc8914e86 NAME hu.dwim.asdf FILENAME
    hu_dot_dwim_dot_asdf DEPS ((NAME uiop FILENAME uiop)) DEPENDENCIES (uiop)
    VERSION 20180228-darcs SIBLINGS (hu.dwim.asdf.documentation) PARASITES NIL) */
