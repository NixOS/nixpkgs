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

buildDunePackage rec {
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

  meta = with lib; {
    description = "Progress bar library for OCaml";
    homepage = "https://github.com/CraigFe/progress";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
