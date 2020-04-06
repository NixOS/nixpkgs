{ fetchurl, ... }:
{
  baseName = ''cl-log'';
  version = ''cl-log.1.0.1'';

  description = ''CL-LOG - a general purpose logging utility'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-log/2013-01-28/cl-log.1.0.1.tgz'';
    sha256 = ''0wdbq0x6xn21qp3zd49giss3viv8wbs3ga8bg2grfnmzwfwl0y2d'';
  };

  packageName = "cl-log";

  asdFilesToKeep = ["cl-log.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-log DESCRIPTION CL-LOG - a general purpose logging utility SHA256
    0wdbq0x6xn21qp3zd49giss3viv8wbs3ga8bg2grfnmzwfwl0y2d URL
    http://beta.quicklisp.org/archive/cl-log/2013-01-28/cl-log.1.0.1.tgz MD5
    fb960933eb748c14adc3ccb376ac8066 NAME cl-log FILENAME cl-log DEPS NIL
    DEPENDENCIES NIL VERSION cl-log.1.0.1 SIBLINGS (cl-log-test) PARASITES NIL) */
