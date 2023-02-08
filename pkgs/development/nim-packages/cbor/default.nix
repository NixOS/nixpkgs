{ lib, buildNimPackage, fetchFromSourcehut }:

buildNimPackage rec {
  pname = "cbor";
  version = "20221007";
  src = fetchFromSourcehut {
    owner = "~ehmry";
    repo = "nim_${pname}";
    rev = version;
    hash = "sha256-zFkYsXFRAiBrfz3VNML3l+rYrdJmczl0bfZcJSbHHbM=";
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
