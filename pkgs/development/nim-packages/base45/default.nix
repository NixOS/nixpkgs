{ lib, buildNimPackage, fetchFromSourcehut }:

buildNimPackage rec {
  pname = "base45";
  version = "20230124";
  src = fetchFromSourcehut {
    owner = "~ehmry";
    repo = pname;
    rev = version;
    hash = "sha256-9he+14yYVGt2s1IuRLPRsv23xnJzERkWRvIHr3PxFYk=";
  };
  doCheck = true;
  meta = src.meta // {
    description = "Base45 library for Nim";
    license = lib.licenses.unlicense;
    mainProgram = pname;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
