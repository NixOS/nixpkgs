{ fetchurl, ... }:
rec {
  baseName = ''eos'';
  version = ''20150608-git'';

  parasites = [ "eos-tests" ];

  description = ''UNMAINTAINED fork of 5AM, a test framework'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/eos/2015-06-08/eos-20150608-git.tgz'';
    sha256 = ''0fhcvg59p13h1d5h8fnssa8hn3lh19lzysazvrbxyfizfibyydr8'';
  };

  packageName = "eos";

  asdFilesToKeep = ["eos.asd"];
  overrides = x: x;
}
/* (SYSTEM eos DESCRIPTION UNMAINTAINED fork of 5AM, a test framework SHA256
    0fhcvg59p13h1d5h8fnssa8hn3lh19lzysazvrbxyfizfibyydr8 URL
    http://beta.quicklisp.org/archive/eos/2015-06-08/eos-20150608-git.tgz MD5
    94f6a72534171ff6adcc823c31e3d53f NAME eos FILENAME eos DEPS NIL
    DEPENDENCIES NIL VERSION 20150608-git SIBLINGS NIL PARASITES (eos-tests)) */
