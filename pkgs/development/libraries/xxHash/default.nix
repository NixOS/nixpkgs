{ lib
, stdenv
, fetchFromGitHub
, cmake
, fetchurl
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

  patches = [
    # Merged in https://github.com/Cyan4973/xxHash/pull/649
    # Should be present in next release
    (fetchurl {
      name = "cmakeinstallfix.patch";
      url = "https://github.com/Cyan4973/xxHash/commit/636f966ecc713c84ddd3b7ccfde2bfb2cc7492a0.patch";
      hash = "sha256-fj+5V5mDhFgWGvrG1E4fEekL4eh7as0ouVvY4wnIHjs=";
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
    platforms = platforms.unix;
  };
}
