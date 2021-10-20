/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "smart-buffer";
  version = "20210630-git";

  description = "Smart octets buffer";

  deps = [ args."flexi-streams" args."trivial-gray-streams" args."uiop" args."xsubseq" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/smart-buffer/2021-06-30/smart-buffer-20210630-git.tgz";
    sha256 = "1j90cig9nkh9bim1h0jmgi73q8j3sja6bnn18bb85lalng0p4c2p";
  };

  packageName = "smart-buffer";

  asdFilesToKeep = ["smart-buffer.asd"];
  overrides = x: x;
}
/* (SYSTEM smart-buffer DESCRIPTION Smart octets buffer SHA256
    1j90cig9nkh9bim1h0jmgi73q8j3sja6bnn18bb85lalng0p4c2p URL
    http://beta.quicklisp.org/archive/smart-buffer/2021-06-30/smart-buffer-20210630-git.tgz
    MD5 3533a4884c2c7852961377366627727a NAME smart-buffer FILENAME
    smart-buffer DEPS
    ((NAME flexi-streams FILENAME flexi-streams)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME uiop FILENAME uiop) (NAME xsubseq FILENAME xsubseq))
    DEPENDENCIES (flexi-streams trivial-gray-streams uiop xsubseq) VERSION
    20210630-git SIBLINGS (smart-buffer-test) PARASITES NIL) */
