/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "minheap";
  version = "20160628-git";

  description = "Various heap/priority queue data structures";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/minheap/2016-06-28/minheap-20160628-git.tgz";
    sha256 = "1zjmxivspywf3nr7a5qwih2vf7w62r8pmyq25qhm3a0v2fdaihzz";
  };

  packageName = "minheap";

  asdFilesToKeep = ["minheap.asd"];
  overrides = x: x;
}
/* (SYSTEM minheap DESCRIPTION Various heap/priority queue data structures
    SHA256 1zjmxivspywf3nr7a5qwih2vf7w62r8pmyq25qhm3a0v2fdaihzz URL
    http://beta.quicklisp.org/archive/minheap/2016-06-28/minheap-20160628-git.tgz
    MD5 27a57cdd27e91eb767f1377fcbfe2af3 NAME minheap FILENAME minheap DEPS NIL
    DEPENDENCIES NIL VERSION 20160628-git SIBLINGS (minheap-tests) PARASITES
    NIL) */
