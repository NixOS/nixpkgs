{ lib, fetchPypi, buildPythonPackage, krb5, cython, pytestCheckHook, k5test, which }:

buildPythonPackage rec {
  pname = "krb5";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-brDpHgRNN8s0yEuDExD0pIlR8pAtTrtluXy6xf8bImQ=";
  };

  nativeBuildInputs = [
    krb5.dev # for krb5-config
  ];

  buildInputs = [ cython ];
  checkInputs = [ pytestCheckHook k5test which ];

  meta = with lib; {
    description = "Kerberos API bindings for Python";
    license     = licenses.mit;
    homepage    = "https://github.com/jborean93/pykrb5";
    maintainers = with maintainers; [ csernazs ];
  };
}
