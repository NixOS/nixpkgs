{ stdenv
, lib
, fetchFromGitHub
, cmake
, gflags
, staticOnly ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "crc32c";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "crc32c";
    rev = version;
    sha256 = "0c383p7vkfq9rblww6mqxz8sygycyl27rr0j3bzb8l8ga71710ii";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gflags ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isAarch64 "-march=armv8-a+crc";

  cmakeFlags = [
    "-DCRC32C_INSTALL=1"
    "-DCRC32C_BUILD_TESTS=1"
    "-DCRC32C_BUILD_BENCHMARKS=0"
    "-DCRC32C_USE_GLOG=0"
    "-DINSTALL_GTEST=0"
    "-DBUILD_SHARED_LIBS=${if staticOnly then "0" else "1"}"
  ];

  doCheck = false;
  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    ctest

    runHook postInstallCheck
  '';

  postFixup = ''
    # fix bogus include paths
    for f in $(find $out/lib/cmake -name '*.cmake'); do
      substituteInPlace "$f" --replace "\''${_IMPORT_PREFIX}/$out/include" "\''${_IMPORT_PREFIX}/include"
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/google/crc32c";
    description = "CRC32C implementation with support for CPU-specific acceleration instructions";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ cpcloud ];
  };
}
