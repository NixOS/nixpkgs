{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, ragel
, util-linux
, python3
, boost184
, sqlite
, pcre
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "vectorscan";
  version = "5.4.11";

  src = fetchFromGitHub {
    owner = "VectorCamp";
    repo = "vectorscan";
    rev = "vectorscan/${version}";
    hash = "sha256-wz2oIhau/vjnri3LOyPZSCFAWg694FTLVt7+SZYEsL4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    ragel
    python3
  ] ++ lib.optional stdenv.isLinux util-linux;

  buildInputs = [
    boost184
    sqlite
    pcre
  ];

  # FAT_RUNTIME bundles optimized implementations for different CPU extensions and uses CPUID to
  # transparently select the fastest for the current hardware.
  # This feature is only available on linux for x86, x86_64, and aarch64.
  #
  # If FAT_RUNTIME is not available, we fall back to building for a single extension based
  # on stdenv.hostPlatform.
  #
  # For generic builds (e.g. x86_64) this can mean using an implementation not optimized for the
  # potentially available more modern hardware extensions (e.g. x86_64 with AVX512).
  cmakeFlags = [ (if enableShared then "-DBUILD_SHARED_LIBS=ON" else "BUILD_STATIC_LIBS=ON") ]
    ++
    (if lib.elem stdenv.hostPlatform.system [ "x86_64-linux" "i686-linux" ] then
      [ "-DBUILD_AVX2=ON" "-DBUILD_AVX512=ON" "-DBUILD_AVX512VBMI=ON" "-DFAT_RUNTIME=ON" ]
    else
      (if (stdenv.isLinux && stdenv.isAarch64) then
        [ "-DBUILD_SVE=ON" "-DBUILD_SVE2=ON" "-DBUILD_SVE2_BITPERM=ON" "-DFAT_RUNTIME=ON" ]
      else
        [ "-DFAT_RUNTIME=OFF" ]
          ++ lib.optional stdenv.hostPlatform.avx2Support "-DBUILD_AVX2=ON"
          ++ lib.optional stdenv.hostPlatform.avx512Support "-DBUILD_AVX512=ON"
      )
    );

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    ./bin/unit-hyperscan

    runHook postCheck
  '';

  meta = with lib; {
    description = "A portable fork of the high-performance regular expression matching library";
    longDescription = ''
      A fork of Intel's Hyperscan, modified to run on more platforms. Currently
      ARM NEON/ASIMD is 100% functional, and Power VSX are in development.
      ARM SVE2 will be implemented when hardware becomes accessible to the
      developers. More platforms will follow in the future, on demand/request.

      Vectorscan will follow Intel's API and internal algorithms where possible,
      but will not hesitate to make code changes where it is thought of giving
      better performance or better portability. In addition, the code will be
      gradually simplified and made more uniform and all architecture specific
      code will be abstracted away.
    '';
    homepage = "https://www.vectorcamp.gr/vectorscan/";
    changelog = "https://github.com/VectorCamp/vectorscan/blob/${src.rev}/CHANGELOG-vectorscan.md";
    platforms = platforms.unix;
    license = with licenses; [ bsd3 /* and */ bsd2 /* and */ licenses.boost ];
    maintainers = with maintainers; [ tnias vlaci ];
  };
}
