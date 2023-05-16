{ lib, buildNimPackage, fetchFromSourcehut }:

buildNimPackage rec {
  pname = "cbor";
<<<<<<< HEAD
  version = "20230619";
=======
  version = "20230310";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromSourcehut {
    owner = "~ehmry";
    repo = "nim_${pname}";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-F6T/5bUwrJyhRarTWO9cjbf7UfEOXPNWu6mfVKNZsQA=";
  };
=======
    hash = "sha256-VmSYWgXDJLB2D2m3/ymrEytT2iW5JE56WmDz2MPHAqQ=";
  };
  doCheck = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib;
    src.meta // {
      description =
        "Concise Binary Object Representation decoder and encoder (RFC8949)";
      license = licenses.unlicense;
      maintainers = [ maintainers.ehmry ];
      mainProgram = "cbordiag";
    };
}
