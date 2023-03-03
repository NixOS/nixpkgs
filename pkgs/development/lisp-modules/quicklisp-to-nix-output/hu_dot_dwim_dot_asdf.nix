/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_asdf";
  version = "20200925-darcs";

  description = "Various ASDF extensions such as attached test and documentation system, explicit development support, etc.";

  deps = [ args."asdf" args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.asdf/2020-09-25/hu.dwim.asdf-20200925-darcs.tgz";
    sha256 = "1812gk65x8yy8s817zhzga52zvdlagws4sw6a8f6zk7yaaa6br8h";
  };

  packageName = "hu.dwim.asdf";

  asdFilesToKeep = ["hu.dwim.asdf.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.asdf DESCRIPTION
    Various ASDF extensions such as attached test and documentation system, explicit development support, etc.
    SHA256 1812gk65x8yy8s817zhzga52zvdlagws4sw6a8f6zk7yaaa6br8h URL
    http://beta.quicklisp.org/archive/hu.dwim.asdf/2020-09-25/hu.dwim.asdf-20200925-darcs.tgz
    MD5 feec747077117dd9850db77ed1919c21 NAME hu.dwim.asdf FILENAME
    hu_dot_dwim_dot_asdf DEPS
    ((NAME asdf FILENAME asdf) (NAME uiop FILENAME uiop)) DEPENDENCIES
    (asdf uiop) VERSION 20200925-darcs SIBLINGS (hu.dwim.asdf.documentation)
    PARASITES NIL) */
