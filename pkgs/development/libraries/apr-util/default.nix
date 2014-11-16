{ stdenv, fetchurl, makeWrapper, apr, expat, gnused
, sslSupport ? true, openssl
, bdbSupport ? false, db
, ldapSupport ? true, openldap
, libiconvOrNull
}:

assert sslSupport -> openssl != null;
assert bdbSupport -> db != null;
assert ldapSupport -> openldap != null;

let
  optional = stdenv.lib.optional;
in

stdenv.mkDerivation rec {
  name = "apr-util-1.5.4";

  src = fetchurl {
    url = "mirror://apache/apr/${name}.tar.bz2";
    sha256 = "0bn81pfscy9yjvbmyx442svf43s6dhrdfcsnkpxz43fai5qk5kx6";
  };

  configureFlags = ''
    --with-apr=${apr} --with-expat=${expat}
    --with-crypto
    ${stdenv.lib.optionalString sslSupport "--with-openssl=${openssl}"}
    ${stdenv.lib.optionalString bdbSupport "--with-berkeley-db=${db}"}
    ${stdenv.lib.optionalString ldapSupport "--with-ldap"}
  '';

  propagatedBuildInputs = [ makeWrapper apr expat libiconvOrNull ]
    ++ optional sslSupport openssl
    ++ optional bdbSupport db
    ++ optional ldapSupport openldap;

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
