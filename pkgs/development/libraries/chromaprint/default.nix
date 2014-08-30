{ stdenv, fetchurl, cmake, ffmpeg, boost }:

stdenv.mkDerivation rec {
  name = "chromaprint-${version}";
  version = "1.1";

  src = fetchurl {
    url = "http://bitbucket.org/acoustid/chromaprint/downloads/${name}.tar.gz";
    sha256 = "04nd8xmy4kgnpfffj6hw893f80bwhp43i01zpmrinn3497mdf53b";
  };

  buildInputs = [ cmake ffmpeg boost ];

  cmakeFlags = [ "-DBUILD_EXAMPLES=ON" ];

  postInstall = "installBin examples/fpcalc";

  meta = with stdenv.lib; {
    homepage = "http://acoustid.org/chromaprint";
    description = "AcoustID audio fingerprinting library";
    maintainers = with maintainers; [ emery ];
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
  };
}
