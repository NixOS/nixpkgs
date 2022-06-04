/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_stefil_plus_hu_dot_dwim_dot_def";
  version = "hu.dwim.stefil-stable-git";

  description = "System lacks description";

  deps = [ args."alexandria" args."anaphora" args."hu_dot_dwim_dot_asdf" args."hu_dot_dwim_dot_def" args."hu_dot_dwim_dot_stefil" args."iterate" args."metabang-bind" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.stefil/2021-12-30/hu.dwim.stefil-stable-git.tgz";
    sha256 = "0lvrpl08vkqfhj81za9zj8qyqrc1qzg6xk2jwv0hadacsaxjka12";
  };

  packageName = "hu.dwim.stefil+hu.dwim.def";

  asdFilesToKeep = ["hu.dwim.stefil+hu.dwim.def.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.stefil+hu.dwim.def DESCRIPTION System lacks description
    SHA256 0lvrpl08vkqfhj81za9zj8qyqrc1qzg6xk2jwv0hadacsaxjka12 URL
    http://beta.quicklisp.org/archive/hu.dwim.stefil/2021-12-30/hu.dwim.stefil-stable-git.tgz
    MD5 5340af8dbdd9035275cbf12861b5b2d4 NAME hu.dwim.stefil+hu.dwim.def
    FILENAME hu_dot_dwim_dot_stefil_plus_hu_dot_dwim_dot_def DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf)
     (NAME hu.dwim.def FILENAME hu_dot_dwim_dot_def)
     (NAME hu.dwim.stefil FILENAME hu_dot_dwim_dot_stefil)
     (NAME iterate FILENAME iterate)
     (NAME metabang-bind FILENAME metabang-bind))
    DEPENDENCIES
    (alexandria anaphora hu.dwim.asdf hu.dwim.def hu.dwim.stefil iterate
     metabang-bind)
    VERSION hu.dwim.stefil-stable-git SIBLINGS
    (hu.dwim.stefil+hu.dwim.def+swank hu.dwim.stefil+swank hu.dwim.stefil)
    PARASITES NIL) */
