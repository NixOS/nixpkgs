{
  lib,
  buildDunePackage,
  fmt,
  logs,
  mtime,
  optint,
  terminal,
  vector,
  alcotest,
  astring,
}:

buildDunePackage {
  pname = "progress";

  minimalOCamlVersion = "4.08";

  inherit (terminal) version src;

  propagatedBuildInputs = [
    fmt
    logs
    mtime
    optint
    terminal
    vector
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    astring
  ];

  meta = {
    description = "Progress bar library for OCaml";
    homepage = "https://github.com/CraigFe/progress";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
}
