{ fetchurl, lib, stdenv, cmake, ninja }:

stdenv.mkDerivation rec {
  name = "poppler-data-0.4.11";

  src = fetchurl {
    url = "https://poppler.freedesktop.org/${name}.tar.gz";
    sha256 = "sha256-LOwFzRuwOvmKiwah4i9ubhplseLzgWyzBpuwh0gl8Iw=";
  };

  nativeBuildInputs = [ cmake ninja ];

  meta = with lib; {
    homepage = "https://poppler.freedesktop.org/";
    description = "Encoding files for Poppler, a PDF rendering library";
    platforms = platforms.all;
    license = licenses.free; # more free licenses combined
    maintainers = with maintainers; [ ];
  };
}
