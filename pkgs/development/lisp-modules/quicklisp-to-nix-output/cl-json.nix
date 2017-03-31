args @ { fetchurl, ... }:
rec {
  baseName = ''cl-json'';
  version = ''20141217-git'';

  description = ''JSON in Lisp. JSON (JavaScript Object Notation) is a lightweight data-interchange format.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-json/2014-12-17/cl-json-20141217-git.tgz'';
    sha256 = ''00cfppyi6njsbpv1x03jcv4zwplg0q1138174l3wjkvi3gsql17g'';
  };

  overrides = x: {
  };
}
