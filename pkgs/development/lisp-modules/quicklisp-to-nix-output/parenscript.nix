args @ { fetchurl, ... }:
rec {
  baseName = ''parenscript'';
  version = ''Parenscript-2.6'';

  description = ''Lisp to JavaScript transpiler'';

  deps = [ args."anaphora" args."cl-ppcre" args."named-readtables" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/parenscript/2016-03-18/Parenscript-2.6.tgz'';
    sha256 = ''1hvr407fz7gzaxqbnki4k3l44qvl7vk6p5pn7811nrv6lk3kp5li'';
  };

  overrides = x: {
  };
}
