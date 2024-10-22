{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "xxHash";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "Cyan4973";
    repo = "xxHash";
    rev = "v${version}";
    hash = "sha256-kofPs01jb189LUjYHHt+KxDifZQWl0Hm779711mvWtI=";
  };

  nativeBuildInputs = [
    cmake
  ];

  # Using unofficial CMake build script to install CMake module files.
  cmakeDir = "../cmake_unofficial";

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
    mainProgram = "xxhsum";
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.all;
    pkgConfigModules = [
      "libxxhash"
    ];
  };
}
