{ lib
, stdenv
, fetchFromGitHub
, cmake
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "xxHash";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "Cyan4973";
    repo = "xxHash";
    rev = "v${version}";
    sha256 = "sha256-2WoYCO6QRHWrbGP2mK04/sLNTyQLOuL3urVktilAwMA=";
  };

  # CMake build fixes
  patches = [
    # Merged in https://github.com/Cyan4973/xxHash/pull/649
    # Should be present in next release
    (fetchpatch {
      name = "cmake-install-fix";
      url = "https://github.com/Cyan4973/xxHash/commit/636f966ecc713c84ddd3b7ccfde2bfb2cc7492a0.patch";
      sha256 = "sha256-B1PZ/0BXlOrSiPvgCPLvI/sjQvnR0n5PQHOO38LOij0=";
    })

    # Submitted at https://github.com/Cyan4973/xxHash/pull/723
    (fetchpatch {
      name = "cmake-pkgconfig-fix";
      url = "https://github.com/Cyan4973/xxHash/commit/5db353bbd05ee5eb1f90afc08d10da9416154e55.patch";
      sha256 = "sha256-dElgSu9DVo2hY6TTVHLTtt0zkXmQV3nc9i/KbrDkK8s=";
    })
  ];


  nativeBuildInputs = [
    cmake
  ];

  # Using unofficial CMake build script to install CMake module files.
  cmakeDir = "../cmake_unofficial";

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
  ];

  meta = with lib; {
    description = "Extremely fast hash algorithm";
    longDescription = ''
      xxHash is an Extremely fast Hash algorithm, running at RAM speed limits.
      It successfully completes the SMHasher test suite which evaluates
      collision, dispersion and randomness qualities of hash functions. Code is
      highly portable, and hashes are identical on all platforms (little / big
      endian).
    '';
    homepage = "https://github.com/Cyan4973/xxHash";
    license = with licenses; [ bsd2 gpl2 ];
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.all;
  };
}
