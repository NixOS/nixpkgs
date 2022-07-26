{ stdenv
, fetchurl
, lib
, cmake
, cacert
, fetchpatch
, buildShared ? !stdenv.hostPlatform.isStatic
}:

let
  ldLibPathEnvName = if stdenv.isDarwin
    then "DYLD_LIBRARY_PATH"
    else "LD_LIBRARY_PATH";

  generic = { version, hash, patches ? [] }: stdenv.mkDerivation rec {
    pname = "libressl";
    inherit version;

    src = fetchurl {
      url = "mirror://openbsd/LibreSSL/${pname}-${version}.tar.gz";
      inherit hash;
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
      substituteInPlace CMakeLists.txt \
        --replace 'exec_prefix \''${prefix}' "exec_prefix ${placeholder "bin"}" \
        --replace 'libdir      \''${exec_prefix}' 'libdir \''${prefix}'
    '';

    inherit patches;

    # Since 2.9.x the default location can't be configured from the build using
    # DEFAULT_CA_FILE anymore, instead we have to patch the default value.
    postPatch = ''
      patchShebangs tests/
      ${lib.optionalString (lib.versionAtLeast version "2.9.2") ''
        substituteInPlace ./tls/tls_config.c --replace '"/etc/ssl/cert.pem"' '"${cacert}/etc/ssl/certs/ca-bundle.crt"'
      ''}
    '';

    doCheck = true;
    preCheck = ''
      export PREVIOUS_${ldLibPathEnvName}=$${ldLibPathEnvName}
      export ${ldLibPathEnvName}="$${ldLibPathEnvName}:$(realpath tls/):$(realpath ssl/):$(realpath crypto/)"
    '';
    postCheck = ''
      export ${ldLibPathEnvName}=$PREVIOUS_${ldLibPathEnvName}
    '';

    outputs = [ "bin" "dev" "out" "man" "nc" ];

    postFixup = ''
      moveToOutput "bin/nc" "$nc"
      moveToOutput "bin/openssl" "$bin"
      moveToOutput "bin/ocspcheck" "$bin"
      moveToOutput "share/man/man1/nc.1.gz" "$nc"
    '';

    meta = with lib; {
      description = "Free TLS/SSL implementation";
      homepage    = "https://www.libressl.org";
      license = with licenses; [ publicDomain bsdOriginal bsd0 bsd3 gpl3 isc openssl ];
      platforms   = platforms.all;
      maintainers = with maintainers; [ thoughtpolice fpletz ];
    };
  };

in {
  libressl_3_4 = generic {
    version = "3.4.3";
    hash = "sha256-/4i//jVIGLPM9UXjyv5FTFAxx6dyFwdPUzJx1jw38I0=";
  };

  libressl_3_5 = generic {
    version = "3.5.3";
    hash = "sha256-OrXl6u9pziDGsXDuZNeFtCI19I8uYrCV/KXXtmcriyg=";

    patches = [
      # Fix endianness detection on aarch64-darwin, issue #181187
      (fetchpatch {
        name = "fix-endian-header-detection.patch";
        url = "https://patch-diff.githubusercontent.com/raw/libressl-portable/portable/pull/771.patch";
        sha256 = "sha256-in5U6+sl0HB9qMAtUL6Py4X2rlv0HsqRMIQhhM1oThE=";
      })
    ];
  };
}
