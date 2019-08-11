{ stdenv, fetchPypi, buildPythonPackage, krb5 }:

buildPythonPackage rec {
  pname = "pykerberos";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v47p840myqgc7hr4lir72xshcfpa0w8j9n077h3njpqyn6wlbag";
  };

  nativeBuildInputs = [ krb5 ]; # for krb5-config

  buildInputs = [ krb5 ];

  # there are no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "High-level interface to Kerberos";
    license     = licenses.asl20;
    maintainers = with maintainers; [ catern ];
  };
}
