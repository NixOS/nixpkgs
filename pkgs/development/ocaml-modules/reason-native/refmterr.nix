{ atdgen, re, reason, pastel, ... }:

{
  pname = "refmterr";

  nativeBuildInputs = [
    reason
  ];

  propagatedBuildInputs = [
    atdgen
    re
    pastel
  ];

  meta = {
    description = "An error formatter tool for Reason and OCaml. Takes raw error output from compiler and converts to pretty output";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/refmterr";
    homepage = "https://reason-native.com/docs/refmterr/";
  };
}
