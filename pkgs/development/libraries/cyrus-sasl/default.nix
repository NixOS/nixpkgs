{ lib, stdenv, fetchFromGitHub, openssl, openldap, libkrb5, db, gettext
, pam, fixDarwinDylibNames, autoreconfHook, enableLdap ? false
, buildPackages, pruneLibtoolFiles }:

with lib;
stdenv.mkDerivation rec {
  pname = "cyrus-sasl";
  version = "791631a33d855dcac97c1b940478e87e1161cb9d";

  src = fetchFromGitHub {
    owner = "cyrusimap";
    repo = pname;
    rev = version;
    sha256 = "sha256-/dPJUZyTlNGLxE22pBxKk1qbtGHpsugw+4e7gJmHLto=";
  };

  outputs = [ "bin" "dev" "out" "man" "devdoc" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ autoreconfHook pruneLibtoolFiles ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
  buildInputs =
    [ openssl db gettext libkrb5 ]
    ++ lib.optional enableLdap openldap
    ++ lib.optional stdenv.isLinux pam;

  patches = [
    # SPNEGO support is detected using AC_TRY_RUN, which can't be used when cross-compiling
    # set action-if-cross-compiling to pessimistically disable it
    ./cyrus-sasl-ac-try-run-fix.patch
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
    homepage = "https://www.cyrusimap.org/sasl";
    description = "Library for adding authentication support to connection-based protocols";
    platforms = platforms.unix;
    license = licenses.bsdOriginal;
  };
}
