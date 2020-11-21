{ stdenv, fetchurl, fetchpatch, openssl, cyrus_sasl, db, groff, libtool }:

stdenv.mkDerivation rec {
  name = "openldap-2.4.50";

  src = fetchurl {
    url = "https://www.openldap.org/software/download/OpenLDAP/openldap-release/${name}.tgz";
    sha256 = "1f46nlfwmys110j36sifm7ah8m8f3s10c3vaiikmmigmifapvdaw";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2020-25692.patch";
      url = "https://git.openldap.org/openldap/openldap/-/commit/4c774220a752bf8e3284984890dc0931fe73165d.patch";
      sha256 = "0mpmf2wqn1wsn94qrarahqff9600lb852zpvyh0g8bwr4cmi4bx7";
    })
    (fetchpatch {
      name = "CVE-2020-25709.patch";
      url = "https://git.openldap.org/openldap/openldap/-/commit/67670f4544e28fb09eb7319c39f404e1d3229e65.patch";
      sha256 = "12rks96gzk80892mfjm93rvyda1rv2sh9zqdnz5j885l9wkksfaf";
    })
    (fetchpatch {
      name = "CVE-2020-25710.patch";
      url = "https://git.openldap.org/openldap/openldap/-/commit/bdb0d459187522a6063df13871b82ba8dcc6efe2.patch";
      sha256 = "1v72zcz8dk8mr259ig1xrqqb4rjffzfsbmmzn9jgmi3qnf6cilyk";
    })
  ];

  # TODO: separate "out" and "bin"
  outputs = [ "out" "dev" "man" "devdoc" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ groff ];

  buildInputs = [ openssl cyrus_sasl db libtool ];

  # Disable install stripping as it breaks cross-compiling.
  # We strip binaries anyway in fixupPhase.
  makeFlags= [ "STRIP=" ];

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

  doCheck = false; # needs a running LDAP server

  installFlags = [ "sysconfdir=$(out)/etc" "localstatedir=$(out)/var" ];

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
  '';

  postInstall = ''
    chmod +x "$out"/lib/*.{so,dylib}
  '';

  meta = with stdenv.lib; {
    homepage    = http://www.openldap.org/;
    description = "An open source implementation of the Lightweight Directory Access Protocol";
    license = licenses.openldap;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
