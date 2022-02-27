{ lib, stdenv, fetchurl, openssl, openldap, libkrb5, db, gettext
, pam, fixDarwinDylibNames, autoreconfHook, enableLdap ? false
, buildPackages, pruneLibtoolFiles, nixosTests }:

with lib;
stdenv.mkDerivation rec {
  pname = "cyrus-sasl";
  version = "2.1.28";

  src = fetchurl {
    urls =
      [ "https://github.com/cyrusimap/${pname}/releases/download/${pname}-${version}/${pname}-${version}.tar.gz"
        "http://www.cyrusimap.org/releases/${pname}-${version}.tar.gz"
        "http://www.cyrusimap.org/releases/old/${pname}-${version}.tar.gz"
      ];
    sha256 = "sha256-fM/Gq9Ae1nwaCSSzU+Um8bdmsh9C1FYu5jWo6/xbs4w=";
  };

  patches = [
    # Fix cross-compilation
    ./cyrus-sasl-ac-try-run-fix.patch
  ];

  outputs = [ "bin" "dev" "out" "man" "devdoc" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ autoreconfHook pruneLibtoolFiles ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
  buildInputs =
    [ openssl db gettext libkrb5 ]
    ++ lib.optional enableLdap openldap
    ++ lib.optional stdenv.isLinux pam;

  configureFlags = [
    "--with-openssl=${openssl.dev}"
    "--with-plugindir=${placeholder "out"}/lib/sasl2"
    "--with-saslauthd=/run/saslauthd"
    "--enable-login"
    "--enable-shared"
  ] ++ lib.optional enableLdap "--with-ldap=${openldap.dev}";

  installFlags = lib.optional stdenv.isDarwin [ "framedir=$(out)/Library/Frameworks/SASL2.framework" ];

  passthru.tests = {
    inherit (nixosTests) parsedmarc postfix;
  };

  meta = {
    homepage = "https://www.cyrusimap.org/sasl";
    description = "Library for adding authentication support to connection-based protocols";
    platforms = platforms.unix;
    license = licenses.bsdOriginal;
  };
}
