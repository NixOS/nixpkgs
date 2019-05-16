{ stdenv, fetchurl, lib, cmake }:

let

  generic = { version, sha256 }: stdenv.mkDerivation rec {
    name = "libressl-${version}";
    inherit version;

    src = fetchurl {
      url = "mirror://openbsd/LibreSSL/${name}.tar.gz";
      inherit sha256;
    };

    nativeBuildInputs = [ cmake ];

    cmakeFlags = [ "-DENABLE_NC=ON" "-DBUILD_SHARED_LIBS=ON" ];

    # The autoconf build is broken as of 2.9.1, resulting in the following error:
    # libressl-2.9.1/tls/.libs/libtls.a', needed by 'handshake_table'.
    # Fortunately LibreSSL provides a CMake build as well, so opt for CMake by
    # removing ./configure pre-config.
    preConfigure = ''
      rm configure
    '';

    enableParallelBuilding = true;

    outputs = [ "bin" "dev" "out" "man" "nc" ];

    postFixup = ''
      moveToOutput "bin/nc" "$nc"
      moveToOutput "bin/openssl" "$bin"
      moveToOutput "bin/ocspcheck" "$bin"
      moveToOutput "share/man/man1/nc.1${lib.optionalString (dontGzipMan==null) ".gz"}" "$nc"
    '';

    dontGzipMan = if stdenv.isDarwin then true else null; # not sure what's wrong

    meta = with lib; {
      description = "Free TLS/SSL implementation";
      homepage    = "https://www.libressl.org";
      license = with licenses; [ publicDomain bsdOriginal bsd0 bsd3 gpl3 isc ];
      platforms   = platforms.all;
      maintainers = with maintainers; [ thoughtpolice fpletz globin ];
    };
  };

in {

  libressl_2_7 = generic {
    version = "2.7.5";
    sha256 = "0h60bcx7k72171dwpx4vsbsrxxz9c18v75lh5fj600gghn6h7rdy";
  };

  libressl_2_8 = generic {
    version = "2.8.3";
    sha256 = "0xw4z4z6m7lyf1r4m2w2w1k7as791c04ygnfk4d7d0ki0h9hnr4v";
  };

  libressl_2_9 = generic {
    version = "2.9.1";
    sha256 = "1y32iz64rqh74m1g641b39h3293dqi4la7i0ckai1p4lcs2xvr1r";
  };
}
