{ stdenv, fetchurl, openssl, cyrus_sasl, db, groff, libtool }:

stdenv.mkDerivation rec {
  name = "openldap-2.4.45";

  src = fetchurl {
    url = "https://www.openldap.org/software/download/OpenLDAP/openldap-release/${name}.tgz";
    sha256 = "091qvwk5dkcpp17ziabcnh3rg3m7qwzw2pihfcd1d5fdxgywzmnd";
  };

  patches = [
    (fetchurl {
      url = "https://bz-attachments.freebsd.org/attachment.cgi?id=183223";
      sha256 = "1fiy457hrxmydybjlvn8ypzlavz22cz31q2rga07n32dh4x759r3";
    })
  ];
  patchFlags = [ "-p0" ];

  # TODO: separate "out" and "bin"
  outputs = [ "out" "dev" "man" "devdoc" ];

  enableParallelBuilding = true;

  buildInputs = [ openssl cyrus_sasl db groff libtool ];

  configureFlags =
    [ "--enable-overlays"
      "--disable-dependency-tracking"   # speeds up one-time build
      "--enable-modules"
      "--sysconfdir=/etc"
      "--localstatedir=/var"
      "--enable-crypt"
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
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
