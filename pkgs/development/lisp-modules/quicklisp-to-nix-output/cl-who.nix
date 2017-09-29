args @ { fetchurl, ... }:
rec {
  baseName = ''cl-who'';
  version = ''1.1.4'';

  parasites = [ "cl-who-test" ];

  description = ''(X)HTML generation macros'';

  deps = [ args."flexi-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-who/2014-12-17/cl-who-1.1.4.tgz'';
    sha256 = ''0r9wc92njz1cc7nghgbhdmd7jy216ylhlabfj0vc45bmfa4w44rq'';
  };

  packageName = "cl-who";

  asdFilesToKeep = ["cl-who.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-who DESCRIPTION (X)HTML generation macros SHA256
    0r9wc92njz1cc7nghgbhdmd7jy216ylhlabfj0vc45bmfa4w44rq URL
    http://beta.quicklisp.org/archive/cl-who/2014-12-17/cl-who-1.1.4.tgz MD5
    a9e6f0b6a8aaa247dbf751de2cb550bf NAME cl-who FILENAME cl-who DEPS
    ((NAME flexi-streams FILENAME flexi-streams)) DEPENDENCIES (flexi-streams)
    VERSION 1.1.4 SIBLINGS NIL PARASITES (cl-who-test)) */
