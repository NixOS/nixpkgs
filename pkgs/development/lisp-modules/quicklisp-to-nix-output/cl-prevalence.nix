args @ { fetchurl, ... }:
rec {
  baseName = ''cl-prevalence'';
  version = ''20200715-git'';

  description = ''Common Lisp Prevalence Package'';

  deps = [ args."alexandria" args."bordeaux-threads" args."s-sysdeps" args."s-xml" args."split-sequence" args."usocket" args."usocket-server" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-prevalence/2020-07-15/cl-prevalence-20200715-git.tgz'';
    sha256 = ''1m2wrqnly9i35kjk2wydwywjmwkbh3a3f4ds7wl63q8kpn8g0ibd'';
  };

  packageName = "cl-prevalence";

  asdFilesToKeep = ["cl-prevalence.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-prevalence DESCRIPTION Common Lisp Prevalence Package SHA256
    1m2wrqnly9i35kjk2wydwywjmwkbh3a3f4ds7wl63q8kpn8g0ibd URL
    http://beta.quicklisp.org/archive/cl-prevalence/2020-07-15/cl-prevalence-20200715-git.tgz
    MD5 d01b70db724ac8408b072ac39bbd8837 NAME cl-prevalence FILENAME
    cl-prevalence DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME s-sysdeps FILENAME s-sysdeps) (NAME s-xml FILENAME s-xml)
     (NAME split-sequence FILENAME split-sequence)
     (NAME usocket FILENAME usocket)
     (NAME usocket-server FILENAME usocket-server))
    DEPENDENCIES
    (alexandria bordeaux-threads s-sysdeps s-xml split-sequence usocket
     usocket-server)
    VERSION 20200715-git SIBLINGS (cl-prevalence-test) PARASITES NIL) */
