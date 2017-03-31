args @ { fetchurl, ... }:
rec {
  baseName = ''cl-emb'';
  version = ''20170227-git'';

  description = ''A templating system for Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-emb/2017-02-27/cl-emb-20170227-git.tgz'';
    sha256 = ''03n97xvh3v8bz1p75v1vhryfkjm74v0cr5jwg4rakq9zkchhfk80'';
  };

  overrides = x: {
  };
}
