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
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lqp3jgfngyhaxjgj3n230hn90wsylwilh120yjf62h7b1s02mh8";
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
    homepage = https://github.com/pythongssapi/k5test;
    license = licenses.mit;
    maintainers = [ ];
  };
}
