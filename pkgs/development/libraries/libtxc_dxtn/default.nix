{ stdenv, fetchurl, autoconf, automake, libtool, mesa }:

let version = "1.0.1"; in

stdenv.mkDerivation rec {
  name = "libtxc_dxtn-${version}";

  src = fetchurl {
    url = "http://cgit.freedesktop.org/~mareko/${name}.tar.gz";
    sha256 = "0g6lymik9cs7nbzigwzaf49fnhhfsvjanhg92wykw7rfq9zvkhvv";
  };

  buildInputs = [ autoconf automake libtool mesa ];

  preConfigure = "autoreconf -vfi";

  meta = {
    homepage = http://dri.freedesktop.org/wiki/S3TC;
  };
}
