{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {

  name = "cimg-${version}";
  version = "2.5.5";

  src = fetchurl {
    url = "http://cimg.eu/files/CImg_${version}.zip";
    sha256 = "12jwis90ijakfiqngcd8s4a22wzr32f6midszja9ry41ilv63nic";
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
