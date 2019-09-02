{ stdenv, fetchurl, cmake, boost, ffmpeg }:

stdenv.mkDerivation rec {
  pname = "chromaprint";
  version = "1.3.2";

  src = fetchurl {
    url = "https://bitbucket.org/acoustid/chromaprint/downloads/${pname}-${version}.tar.gz";
    sha256 = "0lln8dh33gslb9cbmd1hcv33pr6jxdwipd8m8gbsyhksiq6r1by3";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost ffmpeg ];

  cmakeFlags = [ "-DBUILD_EXAMPLES=ON" ];

  meta = with stdenv.lib; {
    homepage = https://acoustid.org/chromaprint;
    description = "AcoustID audio fingerprinting library";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
