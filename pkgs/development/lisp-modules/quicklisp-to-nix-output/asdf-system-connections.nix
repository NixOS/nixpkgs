args @ { fetchurl, ... }:
rec {
  baseName = ''asdf-system-connections'';
  version = ''20170124-git'';

  description = ''Allows for ASDF system to be connected so that auto-loading may occur.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/asdf-system-connections/2017-01-24/asdf-system-connections-20170124-git.tgz'';
    sha256 = ''0h8237bq3niw6glcsps77n1ykcmc5bjkcrbjyxjgkmcb1c5kwwpq'';
  };

  packageName = "asdf-system-connections";

  asdFilesToKeep = ["asdf-system-connections.asd"];
  overrides = x: x;
}
/* (SYSTEM asdf-system-connections DESCRIPTION
    Allows for ASDF system to be connected so that auto-loading may occur.
    SHA256 0h8237bq3niw6glcsps77n1ykcmc5bjkcrbjyxjgkmcb1c5kwwpq URL
    http://beta.quicklisp.org/archive/asdf-system-connections/2017-01-24/asdf-system-connections-20170124-git.tgz
    MD5 23bdbb69c433568e3e15ed705b803992 NAME asdf-system-connections FILENAME
    asdf-system-connections DEPS NIL DEPENDENCIES NIL VERSION 20170124-git
    SIBLINGS NIL PARASITES NIL) */
