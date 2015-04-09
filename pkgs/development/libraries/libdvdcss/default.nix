{stdenv, fetchurl}:


with stdenv.lib;
stdenv.mkDerivation rec{
  name = "libdvdcss-${version}";
  version = "1.3.99";
  
  src = fetchurl {
    url = "http://download.videolan.org/pub/libdvdcss/${version}/${name}.tar.bz2";
    sha256 = "0pawkfyvn2h3yl6ph5spcvqxb4fr4yi4wfkvw2xqqcqv2ywzmc08";
  };

  meta = {
    homepage = http://www.videolan.org/developers/libdvdcss.html;
    description = "A library for decrypting DVDs";
    maintainers = [ maintainers.AndersonTorres ];
  };
}
