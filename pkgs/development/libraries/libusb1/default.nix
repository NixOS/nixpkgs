{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libusb-1.0.8";

  src = fetchurl {
    url = "mirror://sourceforge/libusb/${name}.tar.bz2";
    sha256 = "1afvpaqnl5plqg95nkvsl4sj9d6ckrmjq44mql8l4zqgf6jx7l11";
  };

  meta = {
    homepage = http://www.libusb.org;
    description = "User-space USB library";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
