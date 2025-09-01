{
  lib,
  buildDunePackage,
  re,
  reason,
  cli,
  file-context-printer,
  pastel,
  src,
}:

buildDunePackage {
  inherit src;

  pname = "rely";
  version = "4.0.0-unstable-2024-05-07";

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
    description = "Jest-inspired testing framework for native OCaml/Reason";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/rely";
    homepage = "https://reason-native.com/docs/rely/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
