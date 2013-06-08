{ stdenv, fetchurl, apr, expat
, sslSupport ? true, openssl
, bdbSupport ? false, db4
, ldapSupport ? true, openldap
}:

assert sslSupport -> openssl != null;
assert bdbSupport -> db4 != null;
assert ldapSupport -> openldap != null;

stdenv.mkDerivation rec {
  name = "apr-util-1.5.1";

  src = fetchurl {
    url = "mirror://apache/apr/${name}.tar.bz2";
    md5 = "9c1db8606e520f201c451ec9a0b095f6";
  };

  configureFlags = ''
    --with-apr=${apr} --with-expat=${expat}
    --with-crypto
    ${stdenv.lib.optionalString sslSupport "--with-openssl=${openssl}"}
    ${stdenv.lib.optionalString bdbSupport "--with-berkeley-db=${db4}"}
    ${stdenv.lib.optionalString ldapSupport "--with-ldap"}
  '';

  propagatedBuildInputs = stdenv.lib.optional ldapSupport openldap;

  enableParallelBuilding = true;

  passthru = {
    inherit sslSupport bdbSupport ldapSupport;
  };

  meta = {
    homepage = http://apr.apache.org/;
    description = "A companion library to APR, the Apache Portable Runtime";
  };
}
