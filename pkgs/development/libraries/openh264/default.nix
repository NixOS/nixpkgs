{ stdenv, fetchFromGitHub, nasm }:

stdenv.mkDerivation rec {
  pname = "openh264";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sa4n4xshmiiv6h767jjq9qxapxxjwwwm3bpcignkxv5xn5sls5r";
  };

  nativeBuildInputs = [ nasm ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "A codec library which supports H.264 encoding and decoding";
    homepage = "https://www.openh264.org";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
