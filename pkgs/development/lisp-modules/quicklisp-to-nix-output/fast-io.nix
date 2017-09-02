args @ { fetchurl, ... }:
rec {
  baseName = ''fast-io'';
  version = ''20170630-git'';

  description = ''Alternative I/O mechanism to a stream or vector'';

  deps = [ args."alexandria" args."static-vectors" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fast-io/2017-06-30/fast-io-20170630-git.tgz'';
    sha256 = ''0wg40jv6hn4ijks026d2aaz5pr3zfxxzaakyzzjka6981g9rgkrg'';
  };

  packageName = "fast-io";

  asdFilesToKeep = ["fast-io.asd"];
  overrides = x: x;
}
/* (SYSTEM fast-io DESCRIPTION Alternative I/O mechanism to a stream or vector
    SHA256 0wg40jv6hn4ijks026d2aaz5pr3zfxxzaakyzzjka6981g9rgkrg URL
    http://beta.quicklisp.org/archive/fast-io/2017-06-30/fast-io-20170630-git.tgz
    MD5 34bfe5f306f2e0f6da128fe024ee242d NAME fast-io FILENAME fast-io DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME static-vectors FILENAME static-vectors)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (alexandria static-vectors trivial-gray-streams) VERSION
    20170630-git SIBLINGS (fast-io-test) PARASITES NIL) */
