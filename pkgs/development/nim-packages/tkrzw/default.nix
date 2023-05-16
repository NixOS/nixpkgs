{ lib, buildNimPackage, fetchFromSourcehut, pkg-config, tkrzw }:

buildNimPackage rec {
  pname = "tkrzw";
  version = "20220922";
  src = fetchFromSourcehut {
    owner = "~ehmry";
    repo = "nim-${pname}";
    rev = version;
    hash = "sha256-66rUuK+wUrqs1QYjteZcaIrfg+LHQNcR+XM+EtVuGsA=";
  };
  propagatedNativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ tkrzw ];
<<<<<<< HEAD
  meta = with lib;
    src.meta // {
      description = "Nim wrappers over some of the Tkrzw C++ library";
      license = lib.licenses.asl20;
=======
  doCheck = true;
  meta = with lib;
    src.meta // {
      description = "Nim wrappers over some of the Tkrzw C++ library";
      license = lib.licenses.apsl20;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      maintainers = with lib.maintainers; [ ehmry ];
    };
}
