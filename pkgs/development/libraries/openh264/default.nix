{ stdenv, fetchFromGitHub, nasm }:

stdenv.mkDerivation rec {
  pname = "openh264";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wba260n1932vafd5ni2jqv9kzc7lj6a1asm1cqk8jv690m6zvpi";
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
