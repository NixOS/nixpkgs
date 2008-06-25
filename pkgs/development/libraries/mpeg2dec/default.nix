{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "mpeg2dec-0.4.1";
  
  src = fetchurl {
    url = http://libmpeg2.sourceforge.net/files/mpeg2dec-0.4.1.tar.gz;
    sha256 = "1vny7rg0p2rmic71hli2l2612i5yaw8vy0wsnm5nvhwfiw37cjn7";
  };

  configureFlags = "--enable-shared --disable-static";

  meta = {
    homepage = http://libmpeg2.sourceforge.net/;
    description = "A free library for decoding mpeg-2 and mpeg-1 video streams";
  };
}
