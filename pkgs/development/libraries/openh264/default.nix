{ stdenv, fetchurl, nasm }:

stdenv.mkDerivation rec {
  name = "openh264-1.4.0";

  src = fetchurl {
    url = "https://github.com/cisco/openh264/archive/v1.4.0.tar.gz";
    sha256 = "08haj0xkyjlwbpqdinxk0cmvqw89bx89ly0kqs9lf87fy6ksgfd1";
  };

  buildInputs = [ nasm ];

  installPhase = ''
    make PREFIX=$out install
  '';

  meta = with stdenv.lib; {
    description = "A codec library which supports H.264 encoding and decoding";
    homepage = http://www.openh264.org;
    license = stdenv.lib.licenses.bsd2;
  };
}
