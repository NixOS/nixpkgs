{ stdenv, fetchFromGitHub, nasm }:

stdenv.mkDerivation rec {
  name = "openh264-${version}";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = "openh264";
    rev = "v${version}";
    sha256 = "0ywrqni05bh925ws5fmd24bm6h9n6z2wp1q19v545v06biiwr46a";
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
