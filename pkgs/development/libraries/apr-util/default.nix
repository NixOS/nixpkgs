{ stdenv, fetchurl, apr, expat
, bdbSupport ? false, db4 ? null
, ldapSupport ? !stdenv.isDarwin, openldap
}:

assert bdbSupport -> db4 != null;

stdenv.mkDerivation rec {
  name = "apr-util-1.4.1";
  
  src = fetchurl {
    url = "mirror://apache/apr/${name}.tar.bz2";
    md5 = "52b31b33fb1aa16e65ddaefc76e41151";
  };
  
  configureFlags = ''
    --with-apr=${apr} --with-expat=${expat}
    ${if bdbSupport then "--with-berkeley-db=${db4}" else ""}
    ${if ldapSupport then "--with-ldap" else ""}
  '';

  propagatedBuildInputs = stdenv.lib.optional ldapSupport openldap;
  
  passthru = {
    inherit bdbSupport;
    inherit ldapSupport;
  };

  meta = {
    homepage = http://apr.apache.org/;
    description = "A companion library to APR, the Apache Portable Runtime";
  };
}

