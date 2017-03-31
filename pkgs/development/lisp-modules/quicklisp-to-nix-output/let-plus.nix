args @ { fetchurl, ... }:
rec {
  baseName = ''let-plus'';
  version = ''20170124-git'';

  description = ''Destructuring extension of LET*.'';

  deps = [ args."alexandria" args."anaphora" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/let-plus/2017-01-24/let-plus-20170124-git.tgz'';
    sha256 = ''1hfsw4g36vccz2lx6gk375arjj6y85yh9ch3pq7yiybjlxx68xi8'';
  };

  overrides = x: {
  };
}
