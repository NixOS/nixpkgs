{ stdenv, fetchFromGitHub, nasm }:

stdenv.mkDerivation rec {
  name = "openh264-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = "openh264";
    rev = "v${version}";
    sha256 = "0sa4n4xshmiiv6h767jjq9qxapxxjwwwm3bpcignkxv5xn5sls5r";
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
