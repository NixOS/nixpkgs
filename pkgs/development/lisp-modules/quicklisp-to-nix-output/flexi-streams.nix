/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "flexi-streams";
  version = "20220220-git";

  description = "Flexible bivalent streams for Common Lisp";

  deps = [ args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/flexi-streams/2022-02-20/flexi-streams-20220220-git.tgz";
    sha256 = "01p7rzldys6nll0mdn33y0036nn490xing1nnl795y42slz58yd1";
  };

  packageName = "flexi-streams";

  asdFilesToKeep = ["flexi-streams.asd"];
  overrides = x: x;
}
/* (SYSTEM flexi-streams DESCRIPTION Flexible bivalent streams for Common Lisp
    SHA256 01p7rzldys6nll0mdn33y0036nn490xing1nnl795y42slz58yd1 URL
    http://beta.quicklisp.org/archive/flexi-streams/2022-02-20/flexi-streams-20220220-git.tgz
    MD5 eb1f06b71bb83512d730bb47225a45cb NAME flexi-streams FILENAME
    flexi-streams DEPS
    ((NAME trivial-gray-streams FILENAME trivial-gray-streams)) DEPENDENCIES
    (trivial-gray-streams) VERSION 20220220-git SIBLINGS (flexi-streams-test)
    PARASITES NIL) */
