args @ { fetchurl, ... }:
rec {
  baseName = ''hunchentoot'';
  version = ''1.2.35'';

  description = ''Hunchentoot is a HTTP server based on USOCKET and
  BORDEAUX-THREADS.  It supports HTTP 1.1, serves static files, has a
  simple framework for user-defined handlers and can be extended
  through subclassing.'';

  deps = [ args."bordeaux-threads" args."chunga" args."cl+ssl" args."cl-base64" args."cl-fad" args."cl-ppcre" args."flexi-streams" args."md5" args."rfc2388" args."trivial-backtrace" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/hunchentoot/2016-03-18/hunchentoot-1.2.35.tgz'';
    sha256 = ''0gp2rgndkijjydb1x3p8414ii1z372gzdy945jy0491bcbhygj74'';
  };

  overrides = x: {
  };
}
