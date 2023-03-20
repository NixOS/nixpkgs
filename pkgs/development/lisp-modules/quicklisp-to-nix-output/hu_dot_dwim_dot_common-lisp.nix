/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_common-lisp";
  version = "stable-git";

  description = "A redefinition of the standard Common Lisp package that includes a number of renames and shadows.";

  deps = [ args."hu_dot_dwim_dot_asdf" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.common-lisp/2021-02-28/hu.dwim.common-lisp-stable-git.tgz";
    sha256 = "1v111qvpfs0jml54a4qccyicgq4jg3h72z8484wa1x0acc9hgz76";
  };

  packageName = "hu.dwim.common-lisp";

  asdFilesToKeep = ["hu.dwim.common-lisp.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.common-lisp DESCRIPTION
    A redefinition of the standard Common Lisp package that includes a number of renames and shadows.
    SHA256 1v111qvpfs0jml54a4qccyicgq4jg3h72z8484wa1x0acc9hgz76 URL
    http://beta.quicklisp.org/archive/hu.dwim.common-lisp/2021-02-28/hu.dwim.common-lisp-stable-git.tgz
    MD5 4f0c7a375cc55381efdbeb17ef17dd7d NAME hu.dwim.common-lisp FILENAME
    hu_dot_dwim_dot_common-lisp DEPS
    ((NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf)) DEPENDENCIES
    (hu.dwim.asdf) VERSION stable-git SIBLINGS
    (hu.dwim.common-lisp.documentation) PARASITES NIL) */
