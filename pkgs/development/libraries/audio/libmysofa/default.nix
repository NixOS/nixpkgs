{ stdenv, fetchFromGitHub, cmake, zlib }:

stdenv.mkDerivation rec {
  name = "libmysofa-${version}";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "hoene";
    repo = "libmysofa";
    rev = "v${version}";
    sha256 = "160gcmsn6dwaca29bs95nsgjdalwc299lip0h37k3jcbxxkchgsh";
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
