args: with args;

stdenv.mkDerivation rec {
  name = "libgphoto2-2.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/gphoto/${name}.tar.bz2";
    sha256 = "0yfvpgfly774jnjrfqjf89h99az3sgvzkfpb9diygpk8hmx6phhd";
  };
  buildInputs = [pkgconfig libusb libtool libexif libjpeg];

  meta = {
    license = "LGPL-2";
    homepage = http://www.gphoto.org/proj/libgphoto2;
  };
}
