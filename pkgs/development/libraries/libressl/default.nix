{ stdenv, fetchurl, lib, cmake, cacert, fetchpatch, buildShared ? true }:

let

  generic = { version, sha256, patches ? [] }: stdenv.mkDerivation rec {
    pname = "libressl";
    inherit version;

    src = fetchurl {
      url = "mirror://openbsd/LibreSSL/${pname}-${version}.tar.gz";
      inherit sha256;
    };

    nativeBuildInputs = [ cmake ];

    cmakeFlags = [
      "-DENABLE_NC=ON"
      # Ensure that the output libraries do not require an executable stack.
      # Without this define, assembly files in libcrypto do not include a
      # .note.GNU-stack section, and if that section is missing from any object,
      # the linker will make the stack executable.
      "-DCMAKE_C_FLAGS=-DHAVE_GNU_STACK"
      # libressl will append this to the regular prefix for libdir
      "-DCMAKE_INSTALL_LIBDIR=lib"
    ] ++ lib.optional buildShared "-DBUILD_SHARED_LIBS=ON";

    # The autoconf build is broken as of 2.9.1, resulting in the following error:
    # libressl-2.9.1/tls/.libs/libtls.a', needed by 'handshake_table'.
    # Fortunately LibreSSL provides a CMake build as well, so opt for CMake by
    # removing ./configure pre-config.
    preConfigure = ''
      rm configure
    '';

    inherit patches;

    # Since 2.9.x the default location can't be configured from the build using
    # DEFAULT_CA_FILE anymore, instead we have to patch the default value.
    postPatch = lib.optionalString (lib.versionAtLeast version "2.9.2") ''
      substituteInPlace ./tls/tls_config.c --replace '"/etc/ssl/cert.pem"' '"${cacert}/etc/ssl/certs/ca-bundle.crt"'
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
      license = with licenses; [ publicDomain bsdOriginal bsd0 bsd3 gpl3 isc openssl ];
      platforms   = platforms.all;
      maintainers = with maintainers; [ thoughtpolice fpletz ];
    };
  };

in {

  libressl_2_8 = generic {
    version = "2.8.3";
    sha256 = "0xw4z4z6m7lyf1r4m2w2w1k7as791c04ygnfk4d7d0ki0h9hnr4v";
  };

  libressl_2_9 = generic {
    version = "2.9.2";
    sha256 = "1m6mz515dcbrbnyz8hrpdfjzdmj1c15vbgnqxdxb89g3z9kq3iy4";
    patches = stdenv.lib.optional stdenv.hostPlatform.isMusl [
      (fetchpatch {
        url = "https://github.com/libressl-portable/portable/pull/529/commits/a747aacc23607c993cc481378782b2c7dd5bc53b.patch";
        sha256 = "0wbrcscdkjpk4mhh7f3saghi4smia4lhf7fl6la3ahhgx1krn5zm";
      })
    ];
  };

  libressl_3_0 = generic {
    version = "3.0.2";
    sha256 = "13ir2lpxz8y1m151k7lrx306498nzfhwlvgkgv97v5cvywmifyyz";
  };
}
