{ lib, stdenv, fetchurl, openssl, openldap, kerberos, db, gettext
, pam, fixDarwinDylibNames, autoreconfHook, enableLdap ? false
, buildPackages, pruneLibtoolFiles, fetchpatch }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "cyrus-sasl";
  version = "2.1.27";

  src = fetchurl {
    urls =
      [ "http://www.cyrusimap.org/releases/${pname}-${version}.tar.gz"
        "http://www.cyrusimap.org/releases/old/${pname}-${version}.tar.gz"
      ];
    sha256 = "1m85zcpgfdhm43cavpdkhb1s2zq1b31472hq1w1gs3xh94anp1i6";
  };

  outputs = [ "bin" "dev" "out" "man" "devdoc" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ autoreconfHook fixDarwinDylibNames pruneLibtoolFiles ];
  buildInputs =
    [ openssl db gettext kerberos ]
    ++ lib.optional enableLdap openldap
    ++ lib.optional stdenv.isLinux pam;

  patches = [
    ./missing-size_t.patch # https://bugzilla.redhat.com/show_bug.cgi?id=906519
    ./cyrus-sasl-ac-try-run-fix.patch
    (fetchpatch {
      name = "CVE-2019-19906.patch";
      url = "https://sources.debian.org/data/main/c/cyrus-sasl2/2.1.27+dfsg-1+deb10u1/debian/patches/0021-CVE-2019-19906.patch";
      sha256 = "1n4c5wg7l9j8rlbvx8i605j5d39xmj5wm618k8acxl4fmglcmfls";
    })
  ];

  configureFlags = [
    "--with-openssl=${openssl.dev}"
    "--with-plugindir=${placeholder "out"}/lib/sasl2"
    "--with-saslauthd=/run/saslauthd"
    "--enable-login"
    "--enable-shared"
  ] ++ lib.optional enableLdap "--with-ldap=${openldap.dev}";

  installFlags = lib.optional stdenv.isDarwin [ "framedir=$(out)/Library/Frameworks/SASL2.framework" ];

  meta = {
    homepage = https://www.cyrusimap.org/sasl;
    description = "Library for adding authentication support to connection-based protocols";
    platforms = platforms.unix;
    license = licenses.bsdOriginal;
  };
}
