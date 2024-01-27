/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "smart-buffer";
  version = "20211020-git";

  description = "Smart octets buffer";

  deps = [ args."flexi-streams" args."trivial-gray-streams" args."uiop" args."xsubseq" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/smart-buffer/2021-10-20/smart-buffer-20211020-git.tgz";
    sha256 = "0v25s4msnwi9vn0cwfv3kxamj0mr2xdwngwmxmhh93mr4fkqzdnv";
  };

  packageName = "smart-buffer";

  asdFilesToKeep = ["smart-buffer.asd"];
  overrides = x: x;
}
/* (SYSTEM smart-buffer DESCRIPTION Smart octets buffer SHA256
    0v25s4msnwi9vn0cwfv3kxamj0mr2xdwngwmxmhh93mr4fkqzdnv URL
    http://beta.quicklisp.org/archive/smart-buffer/2021-10-20/smart-buffer-20211020-git.tgz
    MD5 d09d02788667d987b3988b6de09d09c3 NAME smart-buffer FILENAME
    smart-buffer DEPS
    ((NAME flexi-streams FILENAME flexi-streams)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME uiop FILENAME uiop) (NAME xsubseq FILENAME xsubseq))
    DEPENDENCIES (flexi-streams trivial-gray-streams uiop xsubseq) VERSION
    20211020-git SIBLINGS (smart-buffer-test) PARASITES NIL) */
