{ stdenv, fetchurl, apr, expat
, bdbSupport ? false, db4 ? null
, ldapSupport ? true, openldap
}:

assert bdbSupport -> db4 != null;

stdenv.mkDerivation rec {
  name = "apr-util-1.3.10";
  
  src = fetchurl {
    url = "mirror://apache/apr/${name}.tar.bz2";
    sha256 = "1vhps080b0f9z6ibq7xqbhdrclb89min7xwvc2zzc5wf0x4w1h0s";
  };
  
  configureFlags = ''
    --with-apr=${apr} --with-expat=${expat}
    ${if bdbSupport then "--with-berkeley-db=${db4}" else ""}
    ${if ldapSupport then "--with-ldap" else ""}
  '';

  buildInputs = if ldapSupport then [ openldap ] else [];
  
  passthru = {
    inherit bdbSupport;
    inherit ldapSupport;
  };

  meta = {
    homepage = http://apr.apache.org/;
    description = "A companion library to APR, the Apache Portable Runtime";
  };
}

