{ lib, stdenv, fetchurl, fetchpatch, openssl, openldap, libkrb5, db, gettext
, pam, libxcrypt, fixDarwinDylibNames, autoreconfHook, enableLdap ? false
, buildPackages, pruneLibtoolFiles, nixosTests }:

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
    # make compatible with openssl3. can probably be dropped with any release after 2.1.28
    (fetchpatch {
      url = "https://github.com/cyrusimap/cyrus-sasl/compare/cb549ef71c5bb646fe583697ebdcaba93267a237...dfaa62392e7caecc6ecf0097b4d73738ec4fc0a8.patch";
      hash = "sha256-pc0cZqj1QoxDqgd/j/5q3vWONEPrTm4Pr6MzHlfjRCc=";
    })
  ];

  outputs = [ "bin" "dev" "out" "man" "devdoc" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ autoreconfHook pruneLibtoolFiles ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
  buildInputs =
    [ openssl db gettext libkrb5 libxcrypt ]
    ++ lib.optional enableLdap openldap
    ++ lib.optional stdenv.hostPlatform.isLinux pam;

  configureFlags = [
    "--with-openssl=${openssl.dev}"
    "--with-plugindir=${placeholder "out"}/lib/sasl2"
    "--with-saslauthd=/run/saslauthd"
    "--enable-login"
    "--enable-shared"
  ] ++ lib.optional enableLdap "--with-ldap=${openldap.dev}"
    ++ lib.optionals (stdenv.targetPlatform.useLLVM or false) [
      "--disable-sample"
      "CFLAGS=-DTIME_WITH_SYS_TIME"
    ];

  installFlags = lib.optionals stdenv.hostPlatform.isDarwin [ "framedir=$(out)/Library/Frameworks/SASL2.framework" ];

  passthru.tests = {
    inherit (nixosTests) parsedmarc postfix;
  };

  meta = with lib; {
    homepage = "https://www.cyrusimap.org/sasl";
    description = "Library for adding authentication support to connection-based protocols";
    platforms = platforms.unix;
    license = licenses.bsdOriginal;
  };
}
