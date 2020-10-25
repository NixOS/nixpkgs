args @ { fetchurl, ... }:
rec {
  baseName = ''cl_plus_ssl'';
  version = ''cl+ssl-20200610-git'';

  description = ''Common Lisp interface to OpenSSL.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."flexi-streams" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl+ssl/2020-06-10/cl+ssl-20200610-git.tgz'';
    sha256 = ''1kijg8vlwcxraknp4gadf3n5zjchkgg8axr94v3kas9rb717r6ql'';
  };

  packageName = "cl+ssl";

  asdFilesToKeep = ["cl+ssl.asd"];
  overrides = x: x;
}
/* (SYSTEM cl+ssl DESCRIPTION Common Lisp interface to OpenSSL. SHA256
    1kijg8vlwcxraknp4gadf3n5zjchkgg8axr94v3kas9rb717r6ql URL
    http://beta.quicklisp.org/archive/cl+ssl/2020-06-10/cl+ssl-20200610-git.tgz
    MD5 e6f124e4900191b354827312dfc8df3d NAME cl+ssl FILENAME cl_plus_ssl DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME flexi-streams FILENAME flexi-streams)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME uiop FILENAME uiop))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi flexi-streams trivial-features
     trivial-garbage trivial-gray-streams uiop)
    VERSION cl+ssl-20200610-git SIBLINGS (cl+ssl.test) PARASITES NIL) */
