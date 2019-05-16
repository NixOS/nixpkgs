{ stdenv, fetchFromGitHub, cmake, zlib }:

stdenv.mkDerivation rec {
  name = "libmysofa-${version}";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "hoene";
    repo = "libmysofa";
    rev = "v${version}";
    sha256 = "0si0z7cfw6xcs3dkrb4zini55xpxwfp27yl8lbx39gx2pf8v2jls";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];

  cmakeFlags = [ "-DBUILD_TESTS=OFF" ];

  meta = with stdenv.lib; {
    description = "Reader for AES SOFA files to get better HRTFs";
    homepage = https://github.com/hoene/libmysofa;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
