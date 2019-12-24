{ stdenv, fetchurl, lib, cmake }:

let

  generic = { version, sha256 }: stdenv.mkDerivation rec {
    pname = "libressl";
    inherit version;

    src = fetchurl {
      url = "mirror://openbsd/LibreSSL/${pname}-${version}.tar.gz";
      inherit sha256;
    };

    nativeBuildInputs = [ cmake ];

    cmakeFlags = [
      "-DENABLE_NC=ON"
      "-DBUILD_SHARED_LIBS=ON"
      # Ensure that the output libraries do not require an executable stack.
      # Without this define, assembly files in libcrypto do not include a
      # .note.GNU-stack section, and if that section is missing from any object,
      # the linker will make the stack executable.
      "-DCMAKE_C_FLAGS=-DHAVE_GNU_STACK"
      # libressl will append this to the regular prefix for libdir
      "-DCMAKE_INSTALL_LIBDIR=lib"
    ];

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
      license = with licenses; [ publicDomain bsdOriginal bsd0 bsd3 gpl3 isc openssl ];
      platforms   = platforms.all;
      maintainers = with maintainers; [ thoughtpolice fpletz ];
    };
  };

in {

  libressl_2_9 = generic {
    version = "2.9.2";
    sha256 = "1m6mz515dcbrbnyz8hrpdfjzdmj1c15vbgnqxdxb89g3z9kq3iy4";
  };

  libressl_3_0 = generic {
    version = "3.0.2";
    sha256 = "13ir2lpxz8y1m151k7lrx306498nzfhwlvgkgv97v5cvywmifyyz";
  };
}
