/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-gray-streams";
  version = "20210124-git";

  description = "Compatibility layer for Gray Streams (see http://www.cliki.net/Gray%20streams).";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-gray-streams/2021-01-24/trivial-gray-streams-20210124-git.tgz";
    sha256 = "0swqcw3649279qyn5lc42xqgi13jc4kd7hf3iasf4vfli8lhb3n6";
  };

  packageName = "trivial-gray-streams";

  asdFilesToKeep = ["trivial-gray-streams.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-gray-streams DESCRIPTION
    Compatibility layer for Gray Streams (see http://www.cliki.net/Gray%20streams).
    SHA256 0swqcw3649279qyn5lc42xqgi13jc4kd7hf3iasf4vfli8lhb3n6 URL
    http://beta.quicklisp.org/archive/trivial-gray-streams/2021-01-24/trivial-gray-streams-20210124-git.tgz
    MD5 1b93af1cae9f8465d813964db4d10588 NAME trivial-gray-streams FILENAME
    trivial-gray-streams DEPS NIL DEPENDENCIES NIL VERSION 20210124-git
    SIBLINGS (trivial-gray-streams-test) PARASITES NIL) */
