args @ { fetchurl, ... }:
rec {
  baseName = ''babel'';
  version = ''20150608-git'';

  description = ''Babel, a charset conversion library.'';

  deps = [ args."trivial-features" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/babel/2015-06-08/babel-20150608-git.tgz'';
    sha256 = ''0nv2w7k33rwc4dwi33ay2rkmvnj4vsz9ar27z8fiar34895vndk5'';
  };
}
