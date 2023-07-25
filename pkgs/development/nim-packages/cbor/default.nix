{ lib, buildNimPackage, fetchFromSourcehut }:

buildNimPackage rec {
  pname = "cbor";
  version = "20230619";
  src = fetchFromSourcehut {
    owner = "~ehmry";
    repo = "nim_${pname}";
    rev = version;
    hash = "sha256-F6T/5bUwrJyhRarTWO9cjbf7UfEOXPNWu6mfVKNZsQA=";
  };
  meta = with lib;
    src.meta // {
      description =
        "Concise Binary Object Representation decoder and encoder (RFC8949)";
      license = licenses.unlicense;
      maintainers = [ maintainers.ehmry ];
      mainProgram = "cbordiag";
    };
}
