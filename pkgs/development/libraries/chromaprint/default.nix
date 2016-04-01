{ stdenv, fetchurl, cmake, boost, ffmpeg }:

stdenv.mkDerivation rec {
  name = "chromaprint-${version}";
  version = "1.3.1";

  src = fetchurl {
    url = "http://bitbucket.org/acoustid/chromaprint/downloads/${name}.tar.gz";
    sha256 = "10dm9cfqb77g12pyjnqaw80860kzdcvskni02ll7afpywq8s15cg";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost ffmpeg ];

  cmakeFlags = [ "-DBUILD_EXAMPLES=ON" ];

  meta = with stdenv.lib; {
    homepage = "http://acoustid.org/chromaprint";
    description = "AcoustID audio fingerprinting library";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
  };
}
