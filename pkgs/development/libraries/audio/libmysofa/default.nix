{ stdenv, fetchFromGitHub, cmake, zlib }:

stdenv.mkDerivation rec {
  pname = "libmysofa";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "hoene";
    repo = "libmysofa";
    rev = "v${version}";
    sha256 = "10pz9n99cl2j72m7bdj8xka5akyk0sjbysr7rlfdq0qfkiq5922v";
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
