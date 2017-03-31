args @ { fetchurl, ... }:
rec {
  baseName = ''caveman'';
  version = ''20161031-git'';

  description = ''Web Application Framework for Common Lisp'';

  deps = [ args."anaphora" args."cl-emb" args."cl-ppcre" args."cl-project" args."cl-syntax" args."cl-syntax-annot" args."clack-v1-compat" args."do-urlencode" args."local-time" args."myway" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/caveman/2016-10-31/caveman-20161031-git.tgz'';
    sha256 = ''111zxnlsn99sybmwgyxh0x29avq898nxssysvaf8v4mbb6fva2hi'';
  };

  overrides = x: {
  };
}
