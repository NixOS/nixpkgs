/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "jpl-queues";
  version = "0.1";

  description = "A few different kinds of queues, with optional
multithreading synchronization.";

  deps = [ args."alexandria" args."bordeaux-threads" args."jpl-util" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/jpl-queues/2010-10-06/jpl-queues-0.1.tgz";
    sha256 = "1wvvv7j117h9a42qaj1g4fh4mji28xqs7s60rn6d11gk9jl76h96";
  };

  packageName = "jpl-queues";

  asdFilesToKeep = ["jpl-queues.asd"];
  overrides = x: x;
}
/* (SYSTEM jpl-queues DESCRIPTION A few different kinds of queues, with optional
multithreading synchronization.
    SHA256 1wvvv7j117h9a42qaj1g4fh4mji28xqs7s60rn6d11gk9jl76h96 URL
    http://beta.quicklisp.org/archive/jpl-queues/2010-10-06/jpl-queues-0.1.tgz
    MD5 7c3d14c955db0a5c8ece2b9409333ce0 NAME jpl-queues FILENAME jpl-queues
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME jpl-util FILENAME jpl-util))
    DEPENDENCIES (alexandria bordeaux-threads jpl-util) VERSION 0.1 SIBLINGS
    NIL PARASITES NIL) */
