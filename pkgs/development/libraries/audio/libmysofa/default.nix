{ stdenv, fetchFromGitHub, cmake, zlib }:

stdenv.mkDerivation rec {
  pname = "libmysofa";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "hoene";
    repo = "libmysofa";
    rev = "v${version}";
    sha256 = "1gas6fp0xy57wwdvsdfq1yq2hg4zl2c074b260y7hh92z96pj22j";
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
