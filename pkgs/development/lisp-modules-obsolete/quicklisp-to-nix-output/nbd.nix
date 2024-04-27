/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "nbd";
  version = "20200925-git";

  parasites = [ "nbd/simple-in-memory" ];

  description = "Network Block Device server library.";

  deps = [ args."bordeaux-threads" args."flexi-streams" args."lisp-binary" args."wild-package-inferred-system" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/nbd/2020-09-25/nbd-20200925-git.tgz";
    sha256 = "1npq9a8l3mn67n22ywqm8wh6kr9xv9djla2yj2m535gkysrlvnky";
  };

  packageName = "nbd";

  asdFilesToKeep = ["nbd.asd"];
  overrides = x: x;
}
/* (SYSTEM nbd DESCRIPTION Network Block Device server library. SHA256
    1npq9a8l3mn67n22ywqm8wh6kr9xv9djla2yj2m535gkysrlvnky URL
    http://beta.quicklisp.org/archive/nbd/2020-09-25/nbd-20200925-git.tgz MD5
    f32b7a508ac87c1e179c259b171dc837 NAME nbd FILENAME nbd DEPS
    ((NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME lisp-binary FILENAME lisp-binary)
     (NAME wild-package-inferred-system FILENAME wild-package-inferred-system))
    DEPENDENCIES
    (bordeaux-threads flexi-streams lisp-binary wild-package-inferred-system)
    VERSION 20200925-git SIBLINGS NIL PARASITES (nbd/simple-in-memory)) */
