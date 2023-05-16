<<<<<<< HEAD
{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, substituteAll
, findutils
, krb5
, stdenv
=======
{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, substituteAll
, krb5
, findutils
, which
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "k5test";
  version = "0.10.3";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nJ3uvK1joxXoGDPUXp/RK/IBZmQ7iry5/29NaxhMVx8=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit findutils krb5;
      # krb5-config is in dev output
      krb5Dev = krb5.dev;
<<<<<<< HEAD
=======
      which = "${which}/bin/which";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    })
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "k5test" ];

  meta = with lib; {
<<<<<<< HEAD
    broken = stdenv.isDarwin;
=======
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Library for setting up self-contained Kerberos 5 environment";
    homepage = "https://github.com/pythongssapi/k5test";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
