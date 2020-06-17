{ fetchurl, stdenv, cmake, ninja }:

stdenv.mkDerivation rec {
  name = "poppler-data-0.4.9";

  src = fetchurl {
    url = "https://poppler.freedesktop.org/${name}.tar.gz";
    sha256 = "04i0wgdkn5lhda8cyxd1ll4a2p41pwqrwd47n9mdpl7cx5ypx70z";
  };

  nativeBuildInputs = [ cmake ninja ];

  meta = with stdenv.lib; {
    homepage = "https://poppler.freedesktop.org/";
    description = "Encoding files for Poppler, a PDF rendering library";
    platforms = platforms.all;
    license = licenses.free; # more free licenses combined
    maintainers = with maintainers; [ ];
  };
}
