{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "cimg";
  version = "2.8.4";

  src = fetchurl {
    url = "http://cimg.eu/files/CImg_${version}.zip";
    sha256 = "1y4j2dmk4nnc5rx65c2px7r0nfq5117pmqpvi7klp9wmgcjs29gf";
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
    homepage = "http://cimg.eu/";
    license = licenses.cecill-c;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
