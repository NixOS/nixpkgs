args @ { fetchurl, ... }:
rec {
  baseName = ''s-sysdeps'';
  version = ''20200427-git'';

  description = ''An abstraction layer over platform dependent functionality'';

  deps = [ args."alexandria" args."bordeaux-threads" args."split-sequence" args."usocket" args."usocket-server" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/s-sysdeps/2020-04-27/s-sysdeps-20200427-git.tgz'';
    sha256 = ''04dhi0mibqz4i1jly9i6lrd9lf93i25k2f0hba1sqis3x6sm38zy'';
  };

  packageName = "s-sysdeps";

  asdFilesToKeep = ["s-sysdeps.asd"];
  overrides = x: x;
}
/* (SYSTEM s-sysdeps DESCRIPTION
    An abstraction layer over platform dependent functionality SHA256
    04dhi0mibqz4i1jly9i6lrd9lf93i25k2f0hba1sqis3x6sm38zy URL
    http://beta.quicklisp.org/archive/s-sysdeps/2020-04-27/s-sysdeps-20200427-git.tgz
    MD5 2dc062fc985cd3063ef3eddfc544e578 NAME s-sysdeps FILENAME s-sysdeps DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME split-sequence FILENAME split-sequence)
     (NAME usocket FILENAME usocket)
     (NAME usocket-server FILENAME usocket-server))
    DEPENDENCIES
    (alexandria bordeaux-threads split-sequence usocket usocket-server) VERSION
    20200427-git SIBLINGS NIL PARASITES NIL) */
