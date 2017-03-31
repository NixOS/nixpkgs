args @ { fetchurl, ... }:
rec {
  baseName = ''uffi'';
  version = ''20150923-git'';

  description = ''Universal Foreign Function Library for Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/uffi/2015-09-23/uffi-20150923-git.tgz'';
    sha256 = ''1b3mb1ac5hqpn941pmgwkiy241rnin308haxbs2f4rwp2la7wzyy'';
  };

  overrides = x: {
  };
}
