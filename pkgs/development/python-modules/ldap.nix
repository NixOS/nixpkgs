{ buildPythonPackage, isPy3k, fetchurl
, openldap, cyrus_sasl, openssl }:

buildPythonPackage rec {
  pname = "python-ldap";
  version = "2.4.22";
  name = "${pname}-${version}";
  disabled = isPy3k;

  src = fetchurl {
    url = "mirror://pypi/p/python-ldap/python-${name}.tar.gz";
    sha256 = "1dshpq84kl4xpa0hmnjrh6q5h5bybn09r83sa3z3ybr9jlm8gxcy";
  };

  NIX_CFLAGS_COMPILE = "-I${cyrus_sasl.dev}/include/sasl";
  propagatedBuildInputs = [openldap cyrus_sasl openssl];
}
