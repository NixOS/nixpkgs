args @ { fetchurl, ... }:
rec {
  baseName = ''fast-io'';
  version = ''20171023-git'';

  description = ''Alternative I/O mechanism to a stream or vector'';

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."static-vectors" args."trivial-features" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fast-io/2017-10-23/fast-io-20171023-git.tgz'';
    sha256 = ''09w4awnvw772s24ivgzx2irhy701nrsxbim6ip5rc70rfzbff8sl'';
  };

  packageName = "fast-io";

  asdFilesToKeep = ["fast-io.asd"];
  overrides = x: x;
}
/* (SYSTEM fast-io DESCRIPTION Alternative I/O mechanism to a stream or vector
    SHA256 09w4awnvw772s24ivgzx2irhy701nrsxbim6ip5rc70rfzbff8sl URL
    http://beta.quicklisp.org/archive/fast-io/2017-10-23/fast-io-20171023-git.tgz
    MD5 89105f8277f3bf3709fae1b789e3d5ad NAME fast-io FILENAME fast-io DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME static-vectors FILENAME static-vectors)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel static-vectors trivial-features
     trivial-gray-streams)
    VERSION 20171023-git SIBLINGS (fast-io-test) PARASITES NIL) */
