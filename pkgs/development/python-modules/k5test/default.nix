{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, substituteAll
, krb5Full
, findutils
, which
, pythonOlder
}:

buildPythonPackage rec {
  pname = "k5test";
  version = "0.10.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nJ3uvK1joxXoGDPUXp/RK/IBZmQ7iry5/29NaxhMVx8=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit findutils krb5Full;
      # krb5-config is in dev output
      krb5FullDev = krb5Full.dev;
      which = "${which}/bin/which";
    })
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [
    "k5test"
  ];

  meta = with lib; {
    description = "Library for setting up self-contained Kerberos 5 environment";
    homepage = "https://github.com/pythongssapi/k5test";
    changelog = "https://github.com/pythongssapi/k5test/releases/tag/v{version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
  };
}
