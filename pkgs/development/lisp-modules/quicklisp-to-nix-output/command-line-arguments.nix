/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "command-line-arguments";
  version = "20210807-git";

  parasites = [ "command-line-arguments/test" ];

  description = "small library to deal with command-line arguments";

  deps = [ args."alexandria" args."hu_dot_dwim_dot_stefil" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/command-line-arguments/2021-08-07/command-line-arguments-20210807-git.tgz";
    sha256 = "1ggrzdaw79ls7hk629m31z0pikibqi8x1hyi3fwd0zc8w9k3k6wk";
  };

  packageName = "command-line-arguments";

  asdFilesToKeep = ["command-line-arguments.asd"];
  overrides = x: x;
}
/* (SYSTEM command-line-arguments DESCRIPTION
    small library to deal with command-line arguments SHA256
    1ggrzdaw79ls7hk629m31z0pikibqi8x1hyi3fwd0zc8w9k3k6wk URL
    http://beta.quicklisp.org/archive/command-line-arguments/2021-08-07/command-line-arguments-20210807-git.tgz
    MD5 b50ca36f5b2b19d4322ac5b5969fee22 NAME command-line-arguments FILENAME
    command-line-arguments DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME hu.dwim.stefil FILENAME hu_dot_dwim_dot_stefil))
    DEPENDENCIES (alexandria hu.dwim.stefil) VERSION 20210807-git SIBLINGS NIL
    PARASITES (command-line-arguments/test)) */
