args @ { fetchurl, ... }:
rec {
  baseName = ''drakma'';
  version = ''2.0.2'';

  description = ''Full-featured http/https client based on usocket'';

  deps = [ args."puri" args."cl-base64" args."chunga" args."flexi-streams" args."cl-ppcre" args."chipz" args."usocket" args."cl+ssl" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/drakma/2015-10-31/drakma-2.0.2.tgz'';
    sha256 = ''1bpwh19fxd1ncvwai2ab2363bk6qkpwch5sa4csbiawcihyawh2z'';
  };
}
