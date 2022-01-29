{ fetchurl
, lib
, stdenv
, cmake
, ninja
, poppler
}:

stdenv.mkDerivation rec {
  pname = "poppler-data";
  version = "0.4.11";

  src = fetchurl {
    url = "https://poppler.freedesktop.org/${pname}-${version}.tar.gz";
    sha256 = "LOwFzRuwOvmKiwah4i9ubhplseLzgWyzBpuwh0gl8Iw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  meta = with lib; {
    homepage = "https://poppler.freedesktop.org/";
    description = "Encoding files for Poppler, a PDF rendering library";
    platforms = platforms.all;
    license = licenses.free; # more free licenses combined
    maintainers = poppler.meta.maintainers;
  };
}
