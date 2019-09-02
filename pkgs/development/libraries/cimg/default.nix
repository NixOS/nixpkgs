{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "cimg";
  version = "2.7.0";

  src = fetchurl {
    url = "http://cimg.eu/files/CImg_${version}.zip";
    sha256 = "1la6332cppyciyn3pflbchxa3av72a70p0n1c9sm1hgfbjlydqnv";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    install -dm 755 $out/include/CImg/plugins $doc/share/doc/cimg/examples

    install -m 644 CImg.h $out/include/
    cp -dr --no-preserve=ownership examples/* $doc/share/doc/cimg/examples/
    cp -dr --no-preserve=ownership plugins/* $out/include/CImg/plugins/
    cp README.txt $doc/share/doc/cimg/
  '';

  outputs = [ "out" "doc" ];

  meta = with stdenv.lib; {
    description = "A small, open source, C++ toolkit for image processing";
    homepage = http://cimg.eu/;
    license = licenses.cecill-c;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
