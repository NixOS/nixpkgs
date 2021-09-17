{ lib
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
  version = "0.10.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc5e7e5e286b2f331c1396c33f2a1cd8cf34e78d8d482168a50ffd8576a1455c";
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

  pythonImportsCheck = [ "k5test" ];

  meta = with lib; {
    description = "Library for setting up self-contained Kerberos 5 environment";
    homepage = "https://github.com/pythongssapi/k5test";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
