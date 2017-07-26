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
  name = "apr-util-1.6.0";

  src = fetchurl {
    url = "mirror://apache/apr/${name}.tar.bz2";
    sha256 = "0k6a90d67xl36brz69s7adgkswjmw7isnjblm1naqmjblwzwjx44";
  };

  patches = optional stdenv.isFreeBSD ./include-static-dependencies.patch;

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  buildInputs = optional stdenv.isFreeBSD autoreconfHook;

  configureFlags = [ "--with-apr=${apr.dev}" "--with-expat=${expat.dev}" ]
    ++ optional (!stdenv.isCygwin) "--with-crypto"
    ++ optional sslSupport "--with-openssl=${openssl.dev}"
    ++ optional bdbSupport "--with-berkeley-db=${db}"
    ++ optional ldapSupport "--with-ldap=ldap"
    ++ optionals stdenv.isCygwin
      [ "--without-pgsql" "--without-sqlite2" "--without-sqlite3"
        "--without-freetds" "--without-berkeley-db" "--without-crypto" ]
    ;

  propagatedBuildInputs = [ makeWrapper apr expat libiconv ]
    ++ optional sslSupport openssl
    ++ optional bdbSupport db
    ++ optional ldapSupport openldap
    ++ optional stdenv.isFreeBSD cyrus_sasl;

  postInstall = ''
    for f in $out/lib/*.la $out/lib/apr-util-1/*.la; do
      substituteInPlace $f \
        --replace "${expat.dev}/lib" "${expat.out}/lib" \
        --replace "${openssl.dev}/lib" "${openssl.out}/lib"
    done

    # Give apr1 access to sed for runtime invocations.
    wrapProgram $dev/bin/apu-1-config --prefix PATH : "${gnused}/bin"
  '';

  enableParallelBuilding = true;

  passthru = {
    inherit sslSupport bdbSupport ldapSupport;
  };

  meta = {
    homepage = http://apr.apache.org/;
    description = "A companion library to APR, the Apache Portable Runtime";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.unix;
  };
}
