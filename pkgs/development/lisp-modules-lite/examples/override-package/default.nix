# Imagine wanting to use a very specific version of a package, e.g. to fix a
# regression, or a bug:

{
  pkgs ? import ../../../../.. {}
}:

let
  myAlexandria = pkgs.lispPackagesLite.lispDerivation {
    lispSystem = "alexandria";
    src = pkgs.fetchFromGitLab {
      name = "alexandria-src-override";
      domain = "gitlab.common-lisp.net";
      owner = "alexandria";
      repo = "alexandria";
      rev = "72882fc73e1818c51490a22c4670f35af545d868";
      sha256 = "sha256-MDWnAO9QtuMdmDUWAYkHYtatLtcXzQD+UcjONO/tWLg=";
    };
  };
in

# Just overriding alexandria will automatically make packages that /depend/ on
# alexandria pick up on the new definition. Like arrow-macros, for example:
(pkgs.lispPackagesLite.overrideScope' (self: super: {
  alexandria = myAlexandria;
})).arrow-macros
