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

<<<<<<< HEAD
  meta = {
    description = "Progress bar library for OCaml";
    homepage = "https://github.com/CraigFe/progress";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sternenseemann ];
=======
  meta = with lib; {
    description = "Progress bar library for OCaml";
    homepage = "https://github.com/CraigFe/progress";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
