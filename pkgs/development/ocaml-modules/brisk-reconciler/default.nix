{
  buildDunePackage,
  fetchFromGitHub,
  lib,
  reason,
  ppxlib,
  ocaml,
}:

let
  version = "1.0.0-alpha1";
in

buildDunePackage {
  pname = "brisk-reconciler";
  inherit version;

  src = fetchFromGitHub {
    owner = "briskml";
    repo = "brisk-reconciler";
    tag = "v${version}";
    hash = "sha256-Xj6GGsod3lnEEjrzPrlHwQAowq66uz8comlhpWK888k=";
  };

  buildInputs = [
    ppxlib
  ];

  meta = {
    description = "React.js-like reconciler implemented in OCaml/Reason";
    longDescription = ''
      Easily model any `tree-shaped state` with simple `stateful functions`.

      Definitions:
      * tree-shaped state: Any tree shaped-state like the DOM tree, app navigation state, or even rich text document!
      * stateful functions: Functions that maintain state over time. Imagine that you can take any variable in your function and manage its value over the function's invocation. Now, imagine that any function invocation really creates its own "instance" of the function which will track this state separately from other invocations of this function.
    '';
    homepage = "https://github.com/briskml/brisk-reconciler";
    maintainers = with lib.maintainers; [ momeemt ];
    license = lib.licenses.mit;
    broken = lib.versionAtLeast ocaml.version "5.3";
  };
}
