{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, substituteAll
, krb5
, findutils
, which
, pythonOlder
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
      which = "${which}/bin/which";
    })
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "k5test" ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Library for setting up self-contained Kerberos 5 environment";
    homepage = "https://github.com/pythongssapi/k5test";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
