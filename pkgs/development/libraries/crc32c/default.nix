{ stdenv, fetchFromGitHub, cmake, gflags }:
stdenv.mkDerivation rec {
  pname = "crc32c";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "crc32c";
    rev = version;
    sha256 = "1sazkis9rzbrklfrvk7jn1mqywnq4yghmzg94mxd153h8b1sb149";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gflags ];
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isAarch64 "-march=armv8-a+crc";

  meta = with stdenv.lib; {
    homepage = https://github.com/google/crc32c;
    description = "CRC32C implementation with support for CPU-specific acceleration instructions";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ andir ];
  };
}
