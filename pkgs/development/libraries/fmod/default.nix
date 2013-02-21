{stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "fmod-42204";
  src = if stdenv.system == "i686-linux" then
    fetchurl {
      url = http://www.fmod.org/index.php/release/version/fmodapi42204linux.tar.gz;
      sha256 = "64eedc5b37c597eb925de446106d75cab0b5a79697d5ec048d34702812c08563";
    } else if stdenv.system == "x86_64-linux" then
    fetchurl {
      url = http://www.fmod.org/index.php/release/version/fmodapi42204linux64.tar.gz;
      sha256 = "3f2eec8265838a1005febe07c4971660e85010e4622911890642dc438746edf3";
    } else throw "unsupported platform ${stdenv.system} (only i686-linux and x86_64 linux supported yet)";

  preInstall = ''
    sed -e /ldconfig/d -i Makefile
    sed -e s@/usr/local@$out@ -i Makefile
    sed -e s@/include/fmodex@/include@ -i Makefile
    mkdir -p $out/lib
    mkdir -p $out/include
  '';

  meta = {
    homepage = http://www.fmod.org/;
    description = "Programming library and toolkit for the creation and playback of interactive audio";
    license = "unfree";
  };
}
