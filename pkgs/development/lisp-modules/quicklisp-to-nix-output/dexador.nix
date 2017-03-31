args @ { fetchurl, ... }:
rec {
  baseName = ''dexador'';
  version = ''20170227-git'';

  description = ''Yet another HTTP client for Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/dexador/2017-02-27/dexador-20170227-git.tgz'';
    sha256 = ''0fc3hlckxfwz1ymindb9p44c6idfz8z6w5zk8cbd4nvvd0f2a8kz'';
  };

  overrides = x: {
  };
}
