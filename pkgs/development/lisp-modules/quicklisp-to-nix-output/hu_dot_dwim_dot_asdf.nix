args @ { fetchurl, ... }:
{
  baseName = ''hu_dot_dwim_dot_asdf'';
  version = ''20190521-darcs'';

  description = ''Various ASDF extensions such as attached test and documentation system, explicit development support, etc.'';

  deps = [ args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/hu.dwim.asdf/2019-05-21/hu.dwim.asdf-20190521-darcs.tgz'';
    sha256 = ''0rsbv71vyszy8w35yjwb5h6zcmknjq223hkzir79y72qdsc6sabn'';
  };

  packageName = "hu.dwim.asdf";

  asdFilesToKeep = ["hu.dwim.asdf.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.asdf DESCRIPTION
    Various ASDF extensions such as attached test and documentation system, explicit development support, etc.
    SHA256 0rsbv71vyszy8w35yjwb5h6zcmknjq223hkzir79y72qdsc6sabn URL
    http://beta.quicklisp.org/archive/hu.dwim.asdf/2019-05-21/hu.dwim.asdf-20190521-darcs.tgz
    MD5 b359bf05f587196eba172803b5594318 NAME hu.dwim.asdf FILENAME
    hu_dot_dwim_dot_asdf DEPS ((NAME uiop FILENAME uiop)) DEPENDENCIES (uiop)
    VERSION 20190521-darcs SIBLINGS (hu.dwim.asdf.documentation) PARASITES NIL) */
