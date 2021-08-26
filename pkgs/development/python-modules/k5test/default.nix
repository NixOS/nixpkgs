{ lib
, buildPythonPackage
, fetchPypi
, substituteAll
, six
, krb5Full
, findutils
, which
}:

buildPythonPackage rec {
  pname = "k5test";
  version = "0.10.0";

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

  propagatedBuildInputs = [
    six
  ];

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Library for setting up self-contained Kerberos 5 environment";
    homepage = "https://github.com/pythongssapi/k5test";
    license = licenses.mit;
    maintainers = [ ];
  };
}
