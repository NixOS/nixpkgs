args @ { fetchurl, ... }:
rec {
  baseName = ''unix-opts'';
  version = ''20200925-git'';

  parasites = [ "unix-opts/tests" ];

  description = ''minimalistic parser of command line arguments'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/unix-opts/2020-09-25/unix-opts-20200925-git.tgz'';
    sha256 = ''0y7bg825l8my7kpk4iwx0n8wn7rgy7bir60kb0s55g3x0nx5vx35'';
  };

  packageName = "unix-opts";

  asdFilesToKeep = ["unix-opts.asd"];
  overrides = x: x;
}
/* (SYSTEM unix-opts DESCRIPTION minimalistic parser of command line arguments
    SHA256 0y7bg825l8my7kpk4iwx0n8wn7rgy7bir60kb0s55g3x0nx5vx35 URL
    http://beta.quicklisp.org/archive/unix-opts/2020-09-25/unix-opts-20200925-git.tgz
    MD5 cdde0f71cfa437636d20509b4072df0c NAME unix-opts FILENAME unix-opts DEPS
    NIL DEPENDENCIES NIL VERSION 20200925-git SIBLINGS NIL PARASITES
    (unix-opts/tests)) */
