args @ { fetchurl, ... }:
rec {
  baseName = ''drakma'';
  version = ''2.0.2'';

  description = ''Full-featured http/https client based on usocket'';

  deps = [ args."chipz" args."chunga" args."cl+ssl" args."cl-base64" args."cl-ppcre" args."flexi-streams" args."puri" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/drakma/2015-10-31/drakma-2.0.2.tgz'';
    sha256 = ''1bpwh19fxd1ncvwai2ab2363bk6qkpwch5sa4csbiawcihyawh2z'';
  };

  overrides = x: {
  };
}
