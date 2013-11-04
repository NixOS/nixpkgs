{ stdenv, fetchurl, libraw1394, libusb1, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libdc1394avt-2.1.2";

  src = fetchurl {
    url = http://www.alliedvisiontec.com/fileadmin/content/PDF/Software/AVT_software/zip_files/AVTFire4Linux3v0.src.tar;
    sha256 = "13fz3apxcv2rkb34hxd48lbhss6vagp9h96f55148l4mlf5iyyfv";
  };

  unpackPhase = ''
    tar xf $src
    BIGTAR=`echo *`
    tar xf */libdc1394*.tar.gz
    rm -R $BIGTAR
    cd libd*
  '';

  buildInputs = [ libraw1394 libusb1 pkgconfig ];

  meta = {
    homepage = http://www.alliedvisiontec.com/us/products/software/linux/avt-fire4linux.html;
    description = "Capture and control API for IIDC cameras with AVT extensions";
    license = "LGPLv2.1+";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
    broken = true;
  };
}
