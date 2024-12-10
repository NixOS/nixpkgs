{
  re,
  reason,
  cli,
  file-context-printer,
  pastel,
  ...
}:

{
  pname = "rely";

  nativeBuildInputs = [
    reason
  ];

  propagatedBuildInputs = [
    re
    cli
    file-context-printer
    pastel
  ];

  meta = {
    description = "A Jest-inspired testing framework for native OCaml/Reason";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/rely";
    homepage = "https://reason-native.com/docs/rely/";
  };
}
