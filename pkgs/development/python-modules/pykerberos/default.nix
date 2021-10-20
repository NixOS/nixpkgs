{ lib, fetchPypi, buildPythonPackage, krb5 }:

buildPythonPackage rec {
  pname = "pykerberos";
  version = "1.2.3.dev0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17zjiw6rqgfic32px86qls1i3z7anp15dgb3sprbdvywy98alryn";
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
