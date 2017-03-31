args @ { fetchurl, ... }:
rec {
  baseName = ''cxml-test'';
  version = ''cxml-20110619-git'';

  description = '''';

  deps = [ args."cxml-dom" args."cxml-klacks" args."cxml-xml" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cxml/2011-06-19/cxml-20110619-git.tgz'';
    sha256 = ''04k6syn9p7qsazi84kab9n9ki2pb5hrcs0ilw7wikxfqnbabm2yk'';
  };

  overrides = x: {
  };
}
