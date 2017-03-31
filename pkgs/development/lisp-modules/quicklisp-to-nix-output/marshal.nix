args @ { fetchurl, ... }:
rec {
  baseName = ''marshal'';
  version = ''cl-20170124-git'';

  description = ''marshal: Simple (de)serialization of Lisp datastructures.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-marshal/2017-01-24/cl-marshal-20170124-git.tgz'';
    sha256 = ''0z43m3jspl4c4fcbbxm58hxd9k69308pyijgj7grmq6mirkq664d'';
  };

  overrides = x: {
  };
}
