/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "s-sysdeps";
  version = "20210228-git";

  description = "An abstraction layer over platform dependent functionality";

  deps = [ args."alexandria" args."bordeaux-threads" args."split-sequence" args."usocket" args."usocket-server" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/s-sysdeps/2021-02-28/s-sysdeps-20210228-git.tgz";
    sha256 = "0pybgicif1qavvix9183g4ahjrgcax3qf2ab523cas8l79lr1xkw";
  };

  packageName = "s-sysdeps";

  asdFilesToKeep = ["s-sysdeps.asd"];
  overrides = x: x;
}
/* (SYSTEM s-sysdeps DESCRIPTION
    An abstraction layer over platform dependent functionality SHA256
    0pybgicif1qavvix9183g4ahjrgcax3qf2ab523cas8l79lr1xkw URL
    http://beta.quicklisp.org/archive/s-sysdeps/2021-02-28/s-sysdeps-20210228-git.tgz
    MD5 25d8c1673457341bf60a20752fe59772 NAME s-sysdeps FILENAME s-sysdeps DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME split-sequence FILENAME split-sequence)
     (NAME usocket FILENAME usocket)
     (NAME usocket-server FILENAME usocket-server))
    DEPENDENCIES
    (alexandria bordeaux-threads split-sequence usocket usocket-server) VERSION
    20210228-git SIBLINGS NIL PARASITES NIL) */
