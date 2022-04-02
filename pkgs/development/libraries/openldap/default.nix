{ lib, stdenv, fetchurl, openssl, db, groff, libtool, libsodium
, withCyrusSasl ? true
, cyrus_sasl
}:

stdenv.mkDerivation rec {
  pname = "openldap";
  version = "2.4.58";

  src = fetchurl {
    url = "https://www.openldap.org/software/download/OpenLDAP/openldap-release/${pname}-${version}.tgz";
    sha256 = "sha256-V7WSVL4V0L9qmrPVFMHAV3ewISMpFTMTSofJRGj49Hs=";
  };

  # TODO: separate "out" and "bin"
  outputs = [ "out" "dev" "man" "devdoc" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ groff ];

  buildInputs = [ openssl cyrus_sasl db libsodium libtool ];

  # Disable install stripping as it breaks cross-compiling.
  # We strip binaries anyway in fixupPhase.
  makeFlags= [
    "STRIP="
    "prefix=$(out)"
    "moduledir=$(out)/lib/modules"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  preConfigure = lib.optionalString (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11") ''
    MACOSX_DEPLOYMENT_TARGET=10.16
  '';

  configureFlags = [
    "--enable-overlays"
    "--disable-dependency-tracking"   # speeds up one-time build
    "--enable-modules"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--enable-crypt"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--with-yielding_select=yes"
    "ac_cv_func_memcmp_working=yes"
  ] ++ lib.optional (!withCyrusSasl) "--without-cyrus-sasl"
    ++ lib.optional stdenv.isFreeBSD "--with-pic";

  postBuild = ''
    make $makeFlags CC=$CC -C contrib/slapd-modules/passwd/sha2
    make $makeFlags CC=$CC -C contrib/slapd-modules/passwd/pbkdf2
    make $makeFlags CC=$CC -C contrib/slapd-modules/passwd/argon2
  '';

  doCheck = false; # needs a running LDAP server

  installFlags = [
    "sysconfdir=$(out)/etc"
    "localstatedir=$(out)/var"
    "moduledir=$(out)/lib/modules"
    # The argon2 module hardcodes /usr/bin/install as the path for the
    # `install` binary, which is overridden here.
    "INSTALL=install"
  ];

  # 1. Libraries left in the build location confuse `patchelf --shrink-rpath`
  #    Delete these to let patchelf discover the right path instead.
  #    FIXME: that one can be removed when https://github.com/NixOS/patchelf/pull/98
  #    is in Nixpkgs patchelf.
  # 2. Fixup broken libtool for openssl and cyrus_sasl (if it is not disabled)
  preFixup = ''
    rm -r $out/var
    rm -r libraries/*/.libs
    rm -r contrib/slapd-modules/passwd/*/.libs
    for f in $out/lib/libldap.la $out/lib/libldap_r.la; do
      substituteInPlace "$f" --replace '-lssl' '-L${lib.getLib openssl}/lib -lssl'
  '' + lib.optionalString withCyrusSasl ''
      substituteInPlace "$f" --replace '-lsasl2' '-L${cyrus_sasl.out}/lib -lsasl2'
  '' + ''
    done
  '';

  postInstall = ''
    make $installFlags install -C contrib/slapd-modules/passwd/sha2
    make $installFlags install -C contrib/slapd-modules/passwd/pbkdf2
    make $installFlags install-lib -C contrib/slapd-modules/passwd/argon2
    chmod +x "$out"/lib/*.{so,dylib}
  '';

  meta = with lib; {
    homepage = "https://www.openldap.org/";
    description = "An open source implementation of the Lightweight Directory Access Protocol";
    license = licenses.openldap;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
