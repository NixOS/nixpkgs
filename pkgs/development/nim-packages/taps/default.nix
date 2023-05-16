{ lib, buildNimPackage, fetchFromSourcehut, getdns }:

buildNimPackage rec {
  pname = "taps";
<<<<<<< HEAD
  version = "20230331";
=======
  version = "20221228";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromSourcehut {
    owner = "~ehmry";
    repo = "nim_${pname}";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-p2DBJWFwS82oHPq0uMCtZWFbn8GFndEJBjhkHeuPGos=";
=======
    hash = "sha256-0EjMP5pIPJg4/3nzj6ECC68f709TS06OrJlTZ0tavEo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  propagatedBuildInputs = [ getdns ];
  doCheck = false;
  meta = src.meta // {
    description = "Transport Services Interface";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.ehmry ];
  };
}
