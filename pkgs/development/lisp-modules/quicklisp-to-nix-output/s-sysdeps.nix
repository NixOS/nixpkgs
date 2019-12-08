args @ { fetchurl, ... }:
rec {
  baseName = ''s-sysdeps'';
  version = ''20130128-git'';

  description = ''An abstraction layer over platform dependent functionality'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/s-sysdeps/2013-01-28/s-sysdeps-20130128-git.tgz'';
    sha256 = ''048q0mzypnm284bvv7036d4z7bv7rdcqks5l372s74kq279l2y00'';
  };

  packageName = "s-sysdeps";

  asdFilesToKeep = ["s-sysdeps.asd"];
  overrides = x: x;
}
/* (SYSTEM s-sysdeps DESCRIPTION
    An abstraction layer over platform dependent functionality SHA256
    048q0mzypnm284bvv7036d4z7bv7rdcqks5l372s74kq279l2y00 URL
    http://beta.quicklisp.org/archive/s-sysdeps/2013-01-28/s-sysdeps-20130128-git.tgz
    MD5 2fe61fadafd62ef9597e17b4783889ef NAME s-sysdeps FILENAME s-sysdeps DEPS
    NIL DEPENDENCIES NIL VERSION 20130128-git SIBLINGS NIL PARASITES NIL) */
