args @ { fetchurl, ... }:
{
  baseName = ''smart-buffer'';
  version = ''20160628-git'';

  description = ''Smart octets buffer'';

  deps = [ args."flexi-streams" args."trivial-gray-streams" args."uiop" args."xsubseq" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/smart-buffer/2016-06-28/smart-buffer-20160628-git.tgz'';
    sha256 = ''1wp50snkc8739n91xlnfnq1dzz3kfp0awgp92m7xbpcw3hbaib1s'';
  };

  packageName = "smart-buffer";

  asdFilesToKeep = ["smart-buffer.asd"];
  overrides = x: x;
}
/* (SYSTEM smart-buffer DESCRIPTION Smart octets buffer SHA256
    1wp50snkc8739n91xlnfnq1dzz3kfp0awgp92m7xbpcw3hbaib1s URL
    http://beta.quicklisp.org/archive/smart-buffer/2016-06-28/smart-buffer-20160628-git.tgz
    MD5 454d8510618da8111c7ca687549b7035 NAME smart-buffer FILENAME
    smart-buffer DEPS
    ((NAME flexi-streams FILENAME flexi-streams)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME uiop FILENAME uiop) (NAME xsubseq FILENAME xsubseq))
    DEPENDENCIES (flexi-streams trivial-gray-streams uiop xsubseq) VERSION
    20160628-git SIBLINGS (smart-buffer-test) PARASITES NIL) */
