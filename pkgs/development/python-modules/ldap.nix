{ buildPythonPackage, isPy3k, fetchurl
, openldap, cyrus_sasl, openssl }:

buildPythonPackage rec {
  pname = "python-ldap";
  version = "2.4.38";
  name = "${pname}-${version}";
  disabled = isPy3k;

  src = fetchurl {
    url = "mirror://pypi/p/python-ldap/${name}.tar.gz";
    sha256 = "88bab69e519dd8bd83becbe36bd141c174b0fe309e84936cf1bae685b31be779";
  };

  NIX_CFLAGS_COMPILE = "-I${cyrus_sasl.dev}/include/sasl";
  propagatedBuildInputs = [openldap cyrus_sasl openssl];
}
