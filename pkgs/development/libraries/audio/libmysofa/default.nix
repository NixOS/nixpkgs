{ stdenv, fetchFromGitHub, cmake, zlib }:

stdenv.mkDerivation rec {
  pname = "libmysofa";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "hoene";
    repo = "libmysofa";
    rev = "v${version}";
    sha256 = "053inxfl2n6wdgvnn02kf63m92r48ch4wqix9mqf3rgcf1bfkyfa";
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
