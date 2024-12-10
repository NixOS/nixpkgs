{
  reason,
  re,
  pastel,
  ...
}:

{
  pname = "file-context-printer";

  nativeBuildInputs = [
    reason
  ];

  propagatedBuildInputs = [
    re
    pastel
  ];

  meta = {
    description = "Utility for displaying snippets of files on the command line";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/file-context-printer";
    homepage = "https://reason-native.com/docs/file-context-printer/";
  };
}
