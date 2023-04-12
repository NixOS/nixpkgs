{ lib, buildNimPackage, fetchFromSourcehut }:

buildNimPackage rec {
  pname = "cbor";
  version = "20230310";
  src = fetchFromSourcehut {
    owner = "~ehmry";
    repo = "nim_${pname}";
    rev = version;
    hash = "sha256-VmSYWgXDJLB2D2m3/ymrEytT2iW5JE56WmDz2MPHAqQ=";
  };
  doCheck = true;
  meta = with lib;
    src.meta // {
      description =
        "Concise Binary Object Representation decoder and encoder (RFC8949)";
      license = licenses.unlicense;
      maintainers = [ maintainers.ehmry ];
      mainProgram = "cbordiag";
    };
}
