args @ { fetchurl, ... }:
rec {
  baseName = ''xsubseq'';
  version = ''20150113-git'';

  description = ''Efficient way to manage "subseq"s in Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/xsubseq/2015-01-13/xsubseq-20150113-git.tgz'';
    sha256 = ''0ykjhi7pkqcwm00yzhqvngnx07hsvwbj0c72b08rj4dkngg8is5q'';
  };

  overrides = x: {
  };
}
