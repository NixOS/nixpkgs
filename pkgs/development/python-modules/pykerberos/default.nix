{ lib, fetchPypi, buildPythonPackage, krb5 }:

buildPythonPackage rec {
  pname = "pykerberos";
  version = "1.2.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nXAevY/FlsmdMVXVukWBO9WQjSbvg7oK3SUO22IqvtQ=";
  };

  nativeBuildInputs = [ krb5 ]; # for krb5-config

  buildInputs = [ krb5 ];

  # there are no tests
  doCheck = false;
  pythonImportsCheck = [ "kerberos" ];

  meta = with lib; {
    description = "High-level interface to Kerberos";
    license     = licenses.asl20;
    maintainers = with maintainers; [ catern ];
  };
}
