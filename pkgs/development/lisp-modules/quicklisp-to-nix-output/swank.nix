args @ { fetchurl, ... }:
{
  baseName = ''swank'';
  version = ''slime-v2.24'';

  description = ''System lacks description'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/slime/2019-07-10/slime-v2.24.tgz'';
    sha256 = ''0gsq3i5818iwfbh710lf96kb66q3ap3qvvkcj06zyfh30n50x1g6'';
  };

  packageName = "swank";

  asdFilesToKeep = ["swank.asd"];
  overrides = x: x;
}
/* (SYSTEM swank DESCRIPTION System lacks description SHA256
    0gsq3i5818iwfbh710lf96kb66q3ap3qvvkcj06zyfh30n50x1g6 URL
    http://beta.quicklisp.org/archive/slime/2019-07-10/slime-v2.24.tgz MD5
    05f421f7a9dffa4ba206c548524ef1c0 NAME swank FILENAME swank DEPS NIL
    DEPENDENCIES NIL VERSION slime-v2.24 SIBLINGS NIL PARASITES NIL) */
