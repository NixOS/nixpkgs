{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babl-0.1.62";

  src = fetchurl {
    url = "https://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
    sha256 = "047msfzj8v4sfl61a2xhd69r9rh2pjq4lzpk3j10ijyv9qbry9yw";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Image pixel format conversion library";
    homepage = http://gegl.org/babl/;
    license = licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
