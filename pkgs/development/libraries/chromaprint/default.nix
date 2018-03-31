{ stdenv, fetchurl, cmake, boost, ffmpeg }:

stdenv.mkDerivation rec {
  name = "chromaprint-${version}";
  version = "1.4.3";

  src = fetchurl {
    url = "https://github.com/acoustid/chromaprint/releases/download/v${version}/${name}.tar.gz";
    sha256 = "10kz8lncal4s2rp2rqpgc6xyjp0jzcrihgkx7chf127vfs5n067a";
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
