{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "liboop";
  version = "1.0";

  src = fetchurl {
    url = "http://download.ofb.net/liboop/liboop.tar.gz";
    sha256 = "34d83c6e0f09ee15cb2bc3131e219747c3b612bb57cf7d25318ab90da9a2d97c";
  };

  meta = {
    description = "Event loop library";
    homepage = "http://liboop.ofb.net/";
    license = "LGPL";
    platforms = lib.platforms.linux;
  };
}
