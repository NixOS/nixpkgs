{ lib, stdenv, fetchurl, openssl, openldap, kerberos, db, gettext
, pam, fixDarwinDylibNames, autoreconfHook, fetchpatch, enableLdap ? false
, buildPackages }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "cyrus-sasl-${version}${optionalString (kerberos == null) "-without-kerberos"}";
  version = "2.1.27";

  src = fetchurl {
    url = "ftp://ftp.cyrusimap.org/cyrus-sasl/${name}.tar.gz";
    sha256 = "1m85zcpgfdhm43cavpdkhb1s2zq1b31472hq1w1gs3xh94anp1i6";
  };

  outputs = [ "bin" "dev" "out" "man" "devdoc" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ autoreconfHook fixDarwinDylibNames ];
  buildInputs =
    [ openssl db gettext kerberos ]
    ++ lib.optional enableLdap openldap
    ++ lib.optional stdenv.isLinux pam;

  patches = [
    ./missing-size_t.patch # https://bugzilla.redhat.com/show_bug.cgi?id=906519
    ./cyrus-sasl-ac-try-run-fix.patch
  ] ++ lib.optional stdenv.isFreeBSD (
      fetchurl {
        url = "http://www.linuxfromscratch.org/patches/blfs/svn/cyrus-sasl-2.1.26-fixes-3.patch";
        sha256 = "1vh4pc2rxxm6yvykx0b7kg09jbcwcxwv5rs6yq2ag3y8p6a9x86w";
      }
    );

  configureFlags = [
    "--with-openssl=${openssl.dev}"
    "--with-plugindir=${placeholder "out"}/lib/sasl2"
    "--with-saslauthd=/run/saslauthd"
    "--enable-login"
    "--enable-shared"
  ] ++ lib.optional enableLdap "--with-ldap=${openldap.dev}";

  installFlags = lib.optional stdenv.isDarwin [ "framedir=$(out)/Library/Frameworks/SASL2.framework" ];

  postInstall = ''
    for f in $out/lib/*.la $out/lib/sasl2/*.la; do
      substituteInPlace $f --replace "${openssl.dev}/lib" "${openssl.out}/lib"
    done
  '';

  meta = {
    homepage = https://www.cyrusimap.org/sasl;
    description = "Library for adding authentication support to connection-based protocols";
    platforms = platforms.unix;
    license = licenses.bsdOriginal;
  };
}
