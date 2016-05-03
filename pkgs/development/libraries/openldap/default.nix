{ stdenv, fetchurl, libtool, openssl, cyrus_sasl, db, groff }:

stdenv.mkDerivation rec {
  name = "openldap-2.4.44";

  src = fetchurl {
    url = "http://www.openldap.org/software/download/OpenLDAP/openldap-release/${name}.tgz";
    sha256 = "0044p20hx07fwgw2mbwj1fkx04615hhs1qyx4mawj2bhqvrnppnp";
  };

  # TODO: separate "out" and "bin"
  outputs = [ "dev" "out" "man" "docdev" ];

  buildInputs = [ libtool openssl cyrus_sasl db groff ];

  configureFlags =
    [ "--enable-overlays"
      "--disable-dependency-tracking"   # speeds up one-time build
    ] ++ stdenv.lib.optional (openssl == null) "--without-tls"
      ++ stdenv.lib.optional (cyrus_sasl == null) "--without-cyrus-sasl"
      ++ stdenv.lib.optional stdenv.isFreeBSD "--with-pic";

  enableParallelBuilding = true;

  preBuild = ''
    make ''$makeFlags "''${makeFlagsArray[@]}" ''$buildFlags "''${buildFlagsArray[@]}" depend;
  '';

  # long run
  doCheck = false;

  preCheck = ''
    grep -ril /bin/rm tests/ | xargs -n1 -I@ -- sed -i 's:/bin/rm:rm:g' @
    substituteInPlace tests/scripts/test064-constraint \
      --replace /bin/bash ${stdenv.shell}
  '';

  # Fixup broken libtool
  preFixup = ''
    sed -e 's,-lsasl2,-L${cyrus_sasl.out}/lib -lsasl2,' \
        -e 's,-lssl,-L${openssl.out}/lib -lssl,' \
        -i $out/lib/libldap.la -i $out/lib/libldap_r.la
  '';

  # openldap binaries depend on openldap libs, patchelf removes the rpath to its own libraries
  dontPatchELF = 1;

  meta = with stdenv.lib; {
    homepage    = http://www.openldap.org/;
    description = "An open source implementation of the Lightweight Directory Access Protocol";
    license     = with licenses; [ free ];
    maintainers = with maintainers; [ lovek323 mornfall ];
    platforms   = platforms.unix;
  };
}
