{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  python3,
  perl,
  bison,
  flex,
  texinfo,
  perlPackages,

  openldap,
  libcap_ng,
  sqlite,
  openssl,
  db,
  libedit,
  pam,
  krb5,
  libmicrohttpd,
  cjson,

  CoreFoundation,
  Security,
  SystemConfiguration,

  curl,
  jdk_headless,
  unzip,
  which,

  nixosTests,

  withCJSON ? true,
  withCapNG ? stdenv.isLinux,
  # libmicrohttpd should theoretically work for darwin as well, but something is broken.
  # It affects tests check-bx509d and check-httpkadmind.
  withMicroHTTPD ? stdenv.isLinux,
  withOpenLDAP ? true,
  withOpenLDAPAsHDBModule ? false,
  withOpenSSL ? true,
  withSQLite3 ? true,
}:

assert lib.assertMsg (withOpenLDAPAsHDBModule -> withOpenLDAP) ''
  OpenLDAP needs to be enabled in order to build the OpenLDAP HDB Module.
'';

stdenv.mkDerivation {
  pname = "heimdal";
  version = "7.8.0-unstable-2024-09-10";

  src = fetchFromGitHub {
    owner = "heimdal";
    repo = "heimdal";
    rev = "fd2d434dd375c402d803e6f948cfc6e257d3facc";
    hash = "sha256-WA3lo3eD05l7zKuKEVxudMmiG7OvjK/calaUzPQ2pWs=";
  };

  outputs = [
    "out"
    "dev"
    "man"
    "info"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
    perl
    bison
    flex
    perlPackages.JSON
    texinfo
  ];

  buildInputs =
    [
      db
      libedit
      pam
    ]
    ++ lib.optionals (stdenv.isDarwin) [
      CoreFoundation
      Security
      SystemConfiguration
    ]
    ++ lib.optionals (withCJSON) [ cjson ]
    ++ lib.optionals (withCapNG) [ libcap_ng ]
    ++ lib.optionals (withMicroHTTPD) [ libmicrohttpd ]
    ++ lib.optionals (withOpenLDAP) [ openldap ]
    ++ lib.optionals (withOpenSSL) [ openssl ]
    ++ lib.optionals (withSQLite3) [ sqlite ];

  doCheck = true;
  nativeCheckInputs = [
    curl
    jdk_headless
    unzip
    which
  ];

  configureFlags =
    [
      "--with-libedit-include=${libedit.dev}/include"
      "--with-libedit-lib=${libedit}/lib"
      "--with-berkeley-db-include=${db.dev}/include"
      "--with-berkeley-db"

      "--without-x"
      "--disable-afs-string-to-key"
    ]
    ++ lib.optionals (withCapNG) [
      "--with-capng"
    ]
    ++ lib.optionals (withCJSON) [
      "--with-cjson=${cjson}"
    ]
    ++ lib.optionals (withOpenLDAP) [
      "--with-openldap=${openldap.dev}"
    ]
    ++ lib.optionals (withOpenLDAPAsHDBModule) [
      "--enable-hdb-openldap-module"
    ]
    ++ lib.optionals (withSQLite3) [
      "--with-sqlite3=${sqlite.dev}"
    ];

  patches = [
    # Proposed @ https://github.com/heimdal/heimdal/pull/1262
    ./0001-Include-db.h-for-nbdb-compat-mode.patch
    # Proposed @ https://github.com/heimdal/heimdal/pull/1264
    ./0001-Define-HAVE_DB_185_H.patch
    # Proposed @ https://github.com/heimdal/heimdal/pull/1265
    ./0001-Link-tests-with-libresolv.patch
  ];

  # (check-ldap) slapd resides within ${openldap}/libexec,
  #              which is not part of $PATH by default.
  # (check-ldap) prepending ${openldap}/bin to the path to avoid
  #              using the default installation of openldap on unsandboxed darwin systems,
  #              which does not support the new mdb backend at the moment (2024-01-13).
  # (check-ldap) the bdb backend got deprecated in favour of mdb in openldap 2.5.0,
  #              but the heimdal tests still seem to expect bdb as the openldap backend.
  #              This might be fixed upstream in a future update.
  postPatch = ''
    substituteInPlace tests/ldap/slapd-init.in \
      --replace-fail 'SCHEMA_PATHS="' 'SCHEMA_PATHS="${openldap}/etc/schema '
    substituteInPlace tests/ldap/check-ldap.in \
      --replace-fail 'PATH=' 'PATH=${openldap}/libexec:${openldap}/bin:'
    substituteInPlace tests/ldap/slapd.conf \
      --replace-fail 'database	bdb' 'database mdb'
    substituteInPlace tests/kdc/check-iprop.in \
      --replace-fail '/bin/pwd' 'pwd'
  '';

  # (test_cc) heimdal uses librokens implementation of `secure_getenv` on darwin,
  #           which expects either USER or LOGNAME to be set.
  preCheck = lib.optionalString (stdenv.isDarwin) ''
    export USER=nix-builder
  '';

  # We need to build hcrypt for applications like samba
  postBuild = ''
    (cd include/hcrypto; make -j $NIX_BUILD_CORES)
    (cd lib/hcrypto; make -j $NIX_BUILD_CORES)
  '';

  postInstall = ''
    # Install hcrypto
    (cd include/hcrypto; make -j $NIX_BUILD_CORES install)
    (cd lib/hcrypto; make -j $NIX_BUILD_CORES install)

    mkdir -p $dev/bin
    mv $out/bin/krb5-config $dev/bin/

    # asn1 compilers, move them to $dev
    mv $out/libexec/heimdal/* $dev/bin
    rmdir $out/libexec/heimdal

    # compile_et is needed for cross-compiling this package and samba
    mv lib/com_err/.libs/compile_et $dev/bin
  '';

  # Issues with hydra
  #  In file included from hxtool.c:34:0:
  #  hx_locl.h:67:25: fatal error: pkcs10_asn1.h: No such file or directory
  #enableParallelBuilding = true;

  passthru = {
    implementation = "heimdal";
    tests.nixos = nixosTests.kerberos.heimdal;
  };

  meta = with lib; {
    homepage = "https://www.heimdal.software";
    changelog = "https://github.com/heimdal/heimdal/releases";
    description = "An implementation of Kerberos 5 (and some more stuff)";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ h7x4 ];
  };
}
