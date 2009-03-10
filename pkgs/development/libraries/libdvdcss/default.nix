{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libdvdcss-1.2.10";
  
  src = fetchurl {
    url = http://download.videolan.org/pub/libdvdcss/1.2.10/libdvdcss-1.2.10.tar.bz2;
    sha256 = "0812zxg4b6yjkckzwdzfzb4jnffykr9567f9v29barmb2d8ag513";
  };

  meta = {
    homepage = http://www.videolan.org/developers/libdvdcss.html;
    description = "A library for decrypting DVDs";
  };
}
