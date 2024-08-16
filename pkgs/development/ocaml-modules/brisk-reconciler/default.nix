{ buildDunePackage, fetchFromGitHub, lib, reason, ppxlib }:

buildDunePackage rec {
  pname = "brisk-reconciler";
  version = "unstable-2020-12-02";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "briskml";
    repo = "brisk-reconciler";
    rev = "c9d5c4cf5dd17ff2da994de2c3b0f34c72778f70";
    sha256 = "sha256-AAB4ZzBnwfwFXOAqX/sIT6imOl70F0YNMt96SWOOE9w=";
  };

  nativeBuildInputs = [ reason ];

  buildInputs = [
    ppxlib
  ];

  meta = with lib; {
    description = "React.js-like reconciler implemented in OCaml/Reason";
    longDescription = ''
      Easily model any `tree-shaped state` with simple `stateful functions`.

      Definitions:
      * tree-shaped state: Any tree shaped-state like the DOM tree, app navigation state, or even rich text document!
      * stateful functions: Functions that maintain state over time. Imagine that you can take any variable in your function and manage its value over the function's invocation. Now, imagine that any function invocation really creates its own "instance" of the function which will track this state separately from other invocations of this function.
    '';
    homepage = "https://github.com/briskml/brisk-reconciler";
    maintainers = [ ];
    license = licenses.mit;
  };
}
