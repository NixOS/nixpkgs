{ lib, stdenv, fetchFromGitHub, cmake, zlib }:

stdenv.mkDerivation rec {
  pname = "libmysofa";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "hoene";
    repo = "libmysofa";
    rev = "v${version}";
    sha256 = "sha256-QEfkeofsVxB9gyISL/P7bvnbcBuG7Q3A4UoAyQAXxgE=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];

  cmakeFlags = [ "-DBUILD_TESTS=OFF" "-DCODE_COVERAGE=OFF" ];

  meta = with lib; {
    description = "Reader for AES SOFA files to get better HRTFs";
    homepage = "https://github.com/hoene/libmysofa";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
