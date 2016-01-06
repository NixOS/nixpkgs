{ stdenv, fetchurl, makeWrapper, apr, expat, gnused
, sslSupport ? true, openssl
, bdbSupport ? false, db
, ldapSupport ? !stdenv.isCygwin, openldap
, libiconv
, cyrus_sasl, autoreconfHook
}:

assert sslSupport -> openssl != null;
assert bdbSupport -> db != null;
assert ldapSupport -> openldap != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "apr-util-1.5.4";

  src = fetchurl {
    url = "mirror://apache/apr/${name}.tar.bz2";
    sha256 = "0bn81pfscy9yjvbmyx442svf43s6dhrdfcsnkpxz43fai5qk5kx6";
  };

  patches = stdenv.lib.optionals stdenv.isFreeBSD [ ./include-static-dependencies.patch ];

  buildInputs = stdenv.lib.optionals stdenv.isFreeBSD [ autoreconfHook ];

  configureFlags = ''
    --with-apr=${apr} --with-expat=${expat}
    ${optionalString (!stdenv.isCygwin) "--with-crypto"}
    ${stdenv.lib.optionalString sslSupport "--with-openssl=${openssl}"}
    ${stdenv.lib.optionalString bdbSupport "--with-berkeley-db=${db}"}
    ${stdenv.lib.optionalString ldapSupport "--with-ldap=ldap"}${
      optionalString stdenv.isCygwin "--without-pgsql --without-sqlite2 --without-sqlite3 --without-freetds --without-berkeley-db --without-crypto"}
  '';

  propagatedBuildInputs = [ makeWrapper apr expat libiconv ]
    ++ optional sslSupport openssl
    ++ optional bdbSupport db
    ++ optional ldapSupport openldap
    ++ optional stdenv.isFreeBSD cyrus_sasl;

  # Give apr1 access to sed for runtime invocations
  postInstall = ''
    wrapProgram $out/bin/apu-1-config --prefix PATH : "${gnused}/bin"
  '';

  enableParallelBuilding = true;

  passthru = {
    inherit sslSupport bdbSupport ldapSupport;
  };

  meta = {
    homepage = http://apr.apache.org/;
    description = "A companion library to APR, the Apache Portable Runtime";
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
