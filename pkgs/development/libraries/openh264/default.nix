{ stdenv, fetchFromGitHub, nasm }:

stdenv.mkDerivation rec {
  pname = "openh264";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = "openh264";
    rev = "v${version}";
    sha256 = "1pl7hpk25nh7lcx1lbbv984gvnim0d6hxf4qfmrjjfjf6w37sjw4";
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
