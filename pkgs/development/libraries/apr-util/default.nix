{ stdenv, fetchurl, apr, expat
, bdbSupport ? false, db4 ? null
, ldapSupport ? !stdenv.isDarwin, openldap
}:

assert bdbSupport -> db4 != null;

stdenv.mkDerivation rec {
  name = "apr-util-1.3.12";
  
  src = fetchurl {
    url = "mirror://apache/apr/${name}.tar.bz2";
    md5 = "0f671b037ca62751a8a7005578085560";
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

