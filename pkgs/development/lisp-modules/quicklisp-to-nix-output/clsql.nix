args @ { fetchurl, ... }:
rec {
  baseName = ''clsql'';
  version = ''20160208-git'';

  description = ''Common Lisp SQL Interface library'';

  deps = [ args."uffi" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clsql/2016-02-08/clsql-20160208-git.tgz'';
    sha256 = ''0hc97rlfpanp6c1ziis47mrq2fgxbk0h51bhczn8k9xin2qbhhgn'';
  };

  overrides = x: {
  };
}
