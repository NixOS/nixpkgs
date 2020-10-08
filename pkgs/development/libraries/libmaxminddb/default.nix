{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libmaxminddb";
  version = "1.4.3";

  src = fetchurl {
    url = meta.homepage + "/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "0fd4a4sxiiwzbd5h74wl1ijnb7xybjyybb7q41vdq3w8nk3zdzd5";
  };

  meta = with stdenv.lib; {
    description = "C library for working with MaxMind geolocation DB files";
    homepage = "https://github.com/maxmind/libmaxminddb";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat ];
  };
}
