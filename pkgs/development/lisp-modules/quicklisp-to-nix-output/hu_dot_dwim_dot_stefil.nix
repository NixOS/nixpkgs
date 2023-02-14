/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_stefil";
  version = "stable-git";

  parasites = [ "hu.dwim.stefil/test" ];

  description = "A Simple Test Framework In Lisp.";

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.stefil/2021-12-30/hu.dwim.stefil-stable-git.tgz";
    sha256 = "0lvrpl08vkqfhj81za9zj8qyqrc1qzg6xk2jwv0hadacsaxjka12";
  };

  packageName = "hu.dwim.stefil";

  asdFilesToKeep = ["hu.dwim.stefil.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.stefil DESCRIPTION A Simple Test Framework In Lisp. SHA256
    0lvrpl08vkqfhj81za9zj8qyqrc1qzg6xk2jwv0hadacsaxjka12 URL
    http://beta.quicklisp.org/archive/hu.dwim.stefil/2021-12-30/hu.dwim.stefil-stable-git.tgz
    MD5 5340af8dbdd9035275cbf12861b5b2d4 NAME hu.dwim.stefil FILENAME
    hu_dot_dwim_dot_stefil DEPS ((NAME alexandria FILENAME alexandria))
    DEPENDENCIES (alexandria) VERSION stable-git SIBLINGS
    (hu.dwim.stefil+hu.dwim.def+swank hu.dwim.stefil+hu.dwim.def
     hu.dwim.stefil+swank)
    PARASITES (hu.dwim.stefil/test)) */
