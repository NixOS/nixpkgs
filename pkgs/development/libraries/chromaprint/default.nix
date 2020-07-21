{ stdenv, fetchurl, cmake, boost, ffmpeg }:

stdenv.mkDerivation rec {
  pname = "chromaprint";
  version = "1.5.0";

  src = fetchurl {
    url = "https://github.com/acoustid/chromaprint/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "0sknmyl5254rc55bvkhfwpl4dfvz45xglk1rq8zq5crmwq058fjp";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost ffmpeg ];

  cmakeFlags = [ "-DBUILD_EXAMPLES=ON" "-DBUILD_TOOLS=ON" ];

  meta = with stdenv.lib; {
    homepage = "https://acoustid.org/chromaprint";
    description = "AcoustID audio fingerprinting library";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
