{ lib
, stdenv
, fetchurl

# dependencies
, cyrus_sasl
, groff
, libsodium
, libtool
, openssl
, systemdMinimal
, libxcrypt

# passthru
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "openldap";
  version = "2.6.7";

  src = fetchurl {
    url = "https://www.openldap.org/software/download/OpenLDAP/openldap-release/${pname}-${version}.tgz";
    hash = "sha256-zXdfYlyUTteKPaGKA7A7CO6nPIqryXtBuzNumhCVSTA=";
  };

  # TODO: separate "out" and "bin"
  outputs = [
    "out"
    "dev"
    "man"
    "devdoc"
  ];

  __darwinAllowLocalNetworking = true;

  enableParallelBuilding = true;

  nativeBuildInputs = [
    groff
  ];

  buildInputs = [
    (cyrus_sasl.override {
      inherit openssl;
    })
    libsodium
    libtool
    openssl
  ] ++ lib.optionals (stdenv.isLinux) [
    libxcrypt # causes linking issues on *-darwin
    systemdMinimal
  ];

  preConfigure = lib.optionalString (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11") ''
    MACOSX_DEPLOYMENT_TARGET=10.16
  '';

  configureFlags = [
    "--enable-argon2"
    "--enable-crypt"
    "--enable-modules"
    "--enable-overlays"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--with-yielding_select=yes"
    "ac_cv_func_memcmp_working=yes"
  ] ++ lib.optional stdenv.isFreeBSD "--with-pic";

  env.NIX_CFLAGS_COMPILE = toString [ "-DLDAPI_SOCK=\"/run/openldap/ldapi\"" ];

  makeFlags= [
    "CC=${stdenv.cc.targetPrefix}cc"
    "STRIP="  # Disable install stripping as it breaks cross-compiling. We strip binaries anyway in fixupPhase.
    "STRIP_OPTS="
    "prefix=${placeholder "out"}"
    "sysconfdir=/etc"
    "systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    # contrib modules require these
    "moduledir=${placeholder "out"}/lib/modules"
    "mandir=${placeholder "out"}/share/man"
  ];

  extraContribModules = [
    # https://git.openldap.org/openldap/openldap/-/tree/master/contrib/slapd-modules
    "passwd/sha2"
    "passwd/pbkdf2"
    "passwd/totp"
  ];

  postBuild = ''
    for module in $extraContribModules; do
      make $makeFlags CC=$CC -C contrib/slapd-modules/$module
    done
  '';

  preCheck = ''
    substituteInPlace tests/scripts/all \
      --replace "/bin/rm" "rm"

    # skip flaky tests
    rm -f tests/scripts/test063-delta-multiprovider

    # https://bugs.openldap.org/show_bug.cgi?id=10009
    # can probably be re-added once https://github.com/cyrusimap/cyrus-sasl/pull/772
    # has made it to a release
    rm -f tests/scripts/test076-authid-rewrite
  '';

  doCheck = true;

  # The directory is empty and serve no purpose.
  preFixup = ''
    rm -r $out/var
  '';

  installFlags = [
    "prefix=${placeholder "out"}"
    "sysconfdir=${placeholder "out"}/etc"
    "moduledir=${placeholder "out"}/lib/modules"
    "INSTALL=install"
  ];

  postInstall = ''
    for module in $extraContribModules; do
      make $installFlags install -C contrib/slapd-modules/$module
    done
    chmod +x "$out"/lib/*.{so,dylib}
  '';

  passthru.tests = {
    inherit (nixosTests) openldap;
  };

  meta = with lib; {
    homepage = "https://www.openldap.org/";
    description = "An open source implementation of the Lightweight Directory Access Protocol";
    license = licenses.openldap;
    maintainers = with maintainers; [ hexa ] ++ teams.helsinki-systems.members;
    platforms = platforms.unix;
  };
}
