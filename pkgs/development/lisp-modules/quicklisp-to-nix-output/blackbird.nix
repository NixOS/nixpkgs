/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "blackbird";
  version = "20160531-git";

  description = "A promise implementation for Common Lisp.";

  deps = [ args."vom" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/blackbird/2016-05-31/blackbird-20160531-git.tgz";
    sha256 = "0l053fb5fdz1q6dyfgys6nmbairc3aig4wjl5abpf8b1paf7gzq9";
  };

  packageName = "blackbird";

  asdFilesToKeep = ["blackbird.asd"];
  overrides = x: x;
}
/* (SYSTEM blackbird DESCRIPTION A promise implementation for Common Lisp.
    SHA256 0l053fb5fdz1q6dyfgys6nmbairc3aig4wjl5abpf8b1paf7gzq9 URL
    http://beta.quicklisp.org/archive/blackbird/2016-05-31/blackbird-20160531-git.tgz
    MD5 5cb13dc06a0eae8dcba14714d2b5365d NAME blackbird FILENAME blackbird DEPS
    ((NAME vom FILENAME vom)) DEPENDENCIES (vom) VERSION 20160531-git SIBLINGS
    (blackbird-test) PARASITES NIL) */
