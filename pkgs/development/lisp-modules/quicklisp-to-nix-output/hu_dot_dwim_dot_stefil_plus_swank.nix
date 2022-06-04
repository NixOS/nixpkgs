/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_stefil_plus_swank";
  version = "hu.dwim.stefil-stable-git";

  description = "System lacks description";

  deps = [ args."alexandria" args."hu_dot_dwim_dot_asdf" args."hu_dot_dwim_dot_stefil" args."swank" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.stefil/2021-12-30/hu.dwim.stefil-stable-git.tgz";
    sha256 = "0lvrpl08vkqfhj81za9zj8qyqrc1qzg6xk2jwv0hadacsaxjka12";
  };

  packageName = "hu.dwim.stefil+swank";

  asdFilesToKeep = ["hu.dwim.stefil+swank.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.stefil+swank DESCRIPTION System lacks description SHA256
    0lvrpl08vkqfhj81za9zj8qyqrc1qzg6xk2jwv0hadacsaxjka12 URL
    http://beta.quicklisp.org/archive/hu.dwim.stefil/2021-12-30/hu.dwim.stefil-stable-git.tgz
    MD5 5340af8dbdd9035275cbf12861b5b2d4 NAME hu.dwim.stefil+swank FILENAME
    hu_dot_dwim_dot_stefil_plus_swank DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf)
     (NAME hu.dwim.stefil FILENAME hu_dot_dwim_dot_stefil)
     (NAME swank FILENAME swank))
    DEPENDENCIES (alexandria hu.dwim.asdf hu.dwim.stefil swank) VERSION
    hu.dwim.stefil-stable-git SIBLINGS
    (hu.dwim.stefil+hu.dwim.def+swank hu.dwim.stefil+hu.dwim.def
     hu.dwim.stefil)
    PARASITES NIL) */
