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
  version = "0.10.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c9181133f3d52c8e29a5ba970b668273c08f855e5da834aaee2ea9efeb6b069";
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
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Library for setting up self-contained Kerberos 5 environment";
    homepage = "https://github.com/pythongssapi/k5test";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
