args @ { fetchurl, ... }:
{
  baseName = ''hu_dot_dwim_dot_stefil'';
  version = ''20170403-darcs'';

  parasites = [ "hu.dwim.stefil/test" ];

  description = ''A Simple Test Framework In Lisp.'';

  deps = [ args."alexandria" args."hu_dot_dwim_dot_asdf" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/hu.dwim.stefil/2017-04-03/hu.dwim.stefil-20170403-darcs.tgz'';
    sha256 = ''1irrsb0xfc5bx49aqs4ak0xzpjbjhxi9igx5x392gb5pzsak2r9n'';
  };

  packageName = "hu.dwim.stefil";

  asdFilesToKeep = ["hu.dwim.stefil.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.stefil DESCRIPTION A Simple Test Framework In Lisp. SHA256
    1irrsb0xfc5bx49aqs4ak0xzpjbjhxi9igx5x392gb5pzsak2r9n URL
    http://beta.quicklisp.org/archive/hu.dwim.stefil/2017-04-03/hu.dwim.stefil-20170403-darcs.tgz
    MD5 ea8be76a360b1df297a8bbd50be0d8a1 NAME hu.dwim.stefil FILENAME
    hu_dot_dwim_dot_stefil DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf))
    DEPENDENCIES (alexandria hu.dwim.asdf) VERSION 20170403-darcs SIBLINGS
    (hu.dwim.stefil+hu.dwim.def+swank hu.dwim.stefil+hu.dwim.def
     hu.dwim.stefil+swank)
    PARASITES (hu.dwim.stefil/test)) */
