{
  lib,
  buildDunePackage,
  atdgen,
  atdgen-runtime,
  re,
  reason,
  pastel,
  src,
}:

buildDunePackage {
  inherit src;

  pname = "refmterr";
  version = "3.3.0-unstable-2024-05-07";

  postPatch = ''
    substituteInPlace src/refmterr/lib/dune --replace-warn 'atdgen re' 'atdgen-runtime re'
  '';

  nativeBuildInputs = [
    atdgen
    reason
  ];

  propagatedBuildInputs = [
    atdgen-runtime
    re
    pastel
  ];

  meta = {
    description = "Error formatter tool for Reason and OCaml. Takes raw error output from compiler and converts to pretty output";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/refmterr";
    homepage = "https://reason-native.com/docs/refmterr/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
