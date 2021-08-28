/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_defclass-star";
  version = "stable-git";

  description = "Simplify class like definitions with defclass* and friends.";

  deps = [ args."hu_dot_dwim_dot_asdf" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.defclass-star/2021-02-28/hu.dwim.defclass-star-stable-git.tgz";
    sha256 = "1zj4c9pz7y69gclyd7kzf6d6s1r0am49czgvp2axbv7w50j5caf9";
  };

  packageName = "hu.dwim.defclass-star";

  asdFilesToKeep = ["hu.dwim.defclass-star.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.defclass-star DESCRIPTION
    Simplify class like definitions with defclass* and friends. SHA256
    1zj4c9pz7y69gclyd7kzf6d6s1r0am49czgvp2axbv7w50j5caf9 URL
    http://beta.quicklisp.org/archive/hu.dwim.defclass-star/2021-02-28/hu.dwim.defclass-star-stable-git.tgz
    MD5 adb295fecbe4570f4c03dbd857b2ddbc NAME hu.dwim.defclass-star FILENAME
    hu_dot_dwim_dot_defclass-star DEPS
    ((NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf)) DEPENDENCIES
    (hu.dwim.asdf) VERSION stable-git SIBLINGS
    (hu.dwim.defclass-star+contextl hu.dwim.defclass-star+hu.dwim.def+contextl
     hu.dwim.defclass-star+hu.dwim.def hu.dwim.defclass-star+swank
     hu.dwim.defclass-star.documentation hu.dwim.defclass-star.test)
    PARASITES NIL) */
