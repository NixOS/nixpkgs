args @ { fetchurl, ... }:
rec {
  baseName = ''cl-fad'';
  version = ''0.7.4'';

  parasites = [ "cl-fad-test" ];

  description = ''Portable pathname library'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-ppcre" args."unit-test" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-fad/2016-08-25/cl-fad-0.7.4.tgz'';
    sha256 = ''1avp5j66vrpv5symgw4n4szlc2cyqz4haa0cxzy1pl8p0a8k0v9x'';
  };

  packageName = "cl-fad";

  asdFilesToKeep = ["cl-fad.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-fad DESCRIPTION Portable pathname library SHA256
    1avp5j66vrpv5symgw4n4szlc2cyqz4haa0cxzy1pl8p0a8k0v9x URL
    http://beta.quicklisp.org/archive/cl-fad/2016-08-25/cl-fad-0.7.4.tgz MD5
    8ee53f2249eca9d7d54e268662b41845 NAME cl-fad FILENAME cl-fad DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME unit-test FILENAME unit-test))
    DEPENDENCIES (alexandria bordeaux-threads cl-ppcre unit-test) VERSION 0.7.4
    SIBLINGS NIL PARASITES (cl-fad-test)) */
