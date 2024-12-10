{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libcdaudio";
  version = "0.99.12p2";

  src = fetchurl {
    url = "mirror://sourceforge/libcdaudio/libcdaudio-${version}.tar.gz";
    sha256 = "1fsy6dlzxrx177qc877qhajm9l4g28mvh06h2l15rxy4bapzknjz";
  };

  meta = {
    description = "A portable library for controlling audio CDs";
    mainProgram = "libcdaudio-config";
    homepage = "https://libcdaudio.sourceforge.net";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl2;
  };
}
