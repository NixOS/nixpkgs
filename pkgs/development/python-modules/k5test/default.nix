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
  version = "0.10.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QRQw4CxyO83PZmm/4otEJVevvH9ST4qX0fnPKbSIWQ8=";
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
