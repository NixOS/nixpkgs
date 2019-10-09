{ stdenv, fetchFromGitHub, cmake, boost, ffmpeg }:

stdenv.mkDerivation rec {
  pname = "chromaprint";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "acoustid";
    repo = pname;
    rev = "v${version}";
    sha256 = "110js8gspaamqpy6wqshr6vjc55xbgiqy4bqni5jr8ljsialll26";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost ffmpeg ];

  cmakeFlags = [ "-DBUILD_TOOLS=ON" ];

  meta = with stdenv.lib; {
    homepage = https://acoustid.org/chromaprint;
    description = "AcoustID audio fingerprinting library";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
