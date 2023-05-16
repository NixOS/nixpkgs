{ lib
, fetchurl
, buildDunePackage
<<<<<<< HEAD
, saturn
, domain-local-await
, kcas
, mirage-clock-unix
, qcheck-stm
=======
, lockfree
, mirage-clock-unix
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildDunePackage rec {
  pname = "domainslib";
<<<<<<< HEAD
  version = "0.5.1";

  minimalOCamlVersion = "5.0";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/domainslib/releases/download/${version}/domainslib-${version}.tbz";
    hash = "sha256-KMJd+6XZmUSXNsXW/KXgvnFtgY9vODeW3vhL77mDXQE=";
  };

  propagatedBuildInputs = [ domain-local-await saturn ];

  doCheck = true;
  checkInputs = [ kcas mirage-clock-unix qcheck-stm ];
=======
  version = "0.5.0";

  duneVersion = "3";
  minimalOCamlVersion = "5.0";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/domainslib/releases/download/v${version}/domainslib-${version}.tbz";
    hash = "sha256-rty+9DUhTUEcN7BPl8G6Q/G/MJ6z/UAn0RPkG8hACwA=";
  };

  propagatedBuildInputs = [ lockfree ];

  doCheck = true;
  checkInputs = [ mirage-clock-unix ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    homepage = "https://github.com/ocaml-multicore/domainslib";
    description = "Nested-parallel programming";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
