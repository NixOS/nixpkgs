{ stdenv, fetchurl, nasm }:

stdenv.mkDerivation rec {
  name = "openh264-1.5.0";

  src = fetchurl {
    url = "https://github.com/cisco/openh264/archive/v1.5.0.tar.gz";
    sha256 = "1d97dh5hzmy46jamfw03flvcz8md1hxp6y5n0b787h8ks7apn1wq";
  };

  buildInputs = [ nasm ];

  installPhase = ''
    make PREFIX=$out install
  '';

  meta = with stdenv.lib; {
    description = "A codec library which supports H.264 encoding and decoding";
    homepage = http://www.openh264.org;
    license = stdenv.lib.licenses.bsd2;
    platforms = platforms.unix;
  };
}
