{ stdenv, fetchurl, openssl, cyrus_sasl, db, groff }:

stdenv.mkDerivation rec {
  name = "openldap-2.4.42";

  src = fetchurl {
    url = "http://www.openldap.org/software/download/OpenLDAP/openldap-release/${name}.tgz";
    sha256 = "0qwfpb5ipp2l76v11arghq5mr0sjc6xhjfg8a0kgsaw5qpib1dzf";
  };

  # Should be removed with >=2.4.43
  patches = [
    ./CVE-2015-6908.patch
    (
      fetchurl {
        sha256 = "5bcb3f9fb7186b380efa0a1c2d31ad755e190134b5c4dac07c65bbf7c0b6b3b3";
        url = "https://github.com/LMDB/lmdb/commit/3360cbad668f678fb23c064ca4efcc5c9ae95d10.patch";
        name = "openldap-clang-compilation.patch";
      }
    )
  ];

  outputs = [ "out" "man" ];

  buildInputs = [ openssl cyrus_sasl db groff ];

  configureFlags =
    [ "--enable-overlays"
      "--disable-dependency-tracking"   # speeds up one-time build
    ] ++ stdenv.lib.optional (openssl == null) "--without-tls"
      ++ stdenv.lib.optional (cyrus_sasl == null) "--without-cyrus-sasl"
      ++ stdenv.lib.optional stdenv.isFreeBSD "--with-pic";

  dontPatchELF = 1; # !!!

  # Fixup broken libtool
  preFixup = ''
    sed -e 's,-lsasl2,-L${cyrus_sasl}/lib -lsasl2,' \
        -e 's,-lssl,-L${openssl}/lib -lssl,' \
        -i $out/lib/libldap.la -i $out/lib/libldap_r.la
  '';

  meta = with stdenv.lib; {
    homepage    = http://www.openldap.org/;
    description = "An open source implementation of the Lightweight Directory Access Protocol";
    maintainers = with maintainers; [ lovek323 mornfall ];
    platforms   = platforms.unix;
  };
}
