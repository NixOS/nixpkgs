{ stdenv, fetchurl, orc, pkgconfig }:

stdenv.mkDerivation {
  name = "schroedinger-1.0.11";

  src = fetchurl {
    urls = [
      http://diracvideo.org/download/schroedinger/schroedinger-1.0.11.tar.gz
      http://download.videolan.org/contrib/schroedinger-1.0.11.tar.gz
    ];
    sha256 = "04prr667l4sn4zx256v1z36a0nnkxfdqyln48rbwlamr6l3jlmqy";
  };

  outputs = [ "out" "dev" "devdoc" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ orc ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://diracvideo.org/;
    maintainers = [ maintainers.spwhitt ];
    license = [ licenses.mpl11 licenses.lgpl2 licenses.mit ];
    platforms = platforms.unix;
  };
}
