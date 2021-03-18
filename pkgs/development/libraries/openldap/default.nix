{ stdenv, fetchurl, openssl, cyrus_sasl, db, groff, libtool }:

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

  buildInputs = [ openssl cyrus_sasl db libtool ];

  # Disable install stripping as it breaks cross-compiling.
  # We strip binaries anyway in fixupPhase.
  makeFlags= [
    "STRIP="
    "prefix=$(out)"
    "moduledir=$(out)/lib/modules"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  configureFlags = [
    "--enable-overlays"
    "--disable-dependency-tracking"   # speeds up one-time build
    "--enable-modules"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--enable-crypt"
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--with-yielding_select=yes"
    "ac_cv_func_memcmp_working=yes"
  ] ++ stdenv.lib.optional (openssl == null) "--without-tls"
    ++ stdenv.lib.optional (cyrus_sasl == null) "--without-cyrus-sasl"
    ++ stdenv.lib.optional stdenv.isFreeBSD "--with-pic";

  postBuild = ''
    make $makeFlags CC=$CC -C contrib/slapd-modules/passwd/sha2
    make $makeFlags CC=$CC -C contrib/slapd-modules/passwd/pbkdf2
  '';

  doCheck = false; # needs a running LDAP server

  installFlags = [
    "sysconfdir=$(out)/etc"
    "localstatedir=$(out)/var"
    "moduledir=$(out)/lib/modules"
  ];

  # 1. Fixup broken libtool
  # 2. Libraries left in the build location confuse `patchelf --shrink-rpath`
  #    Delete these to let patchelf discover the right path instead.
  #    FIXME: that one can be removed when https://github.com/NixOS/patchelf/pull/98
  #    is in Nixpkgs patchelf.
  preFixup = ''
    sed -e 's,-lsasl2,-L${cyrus_sasl.out}/lib -lsasl2,' \
        -e 's,-lssl,-L${openssl.out}/lib -lssl,' \
        -i $out/lib/libldap.la -i $out/lib/libldap_r.la

    rm -rf $out/var
    rm -r libraries/*/.libs
    rm -r contrib/slapd-modules/passwd/*/.libs
  '';

  postInstall = ''
    make $installFlags install -C contrib/slapd-modules/passwd/sha2
    make $installFlags install -C contrib/slapd-modules/passwd/pbkdf2
    chmod +x "$out"/lib/*.{so,dylib}
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.openldap.org/";
    description = "An open source implementation of the Lightweight Directory Access Protocol";
    license = licenses.openldap;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
